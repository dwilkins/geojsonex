
namespace :import do
  desc 'Import state data from the census'
  task :state, [:state_in] => :environment do |tsk, _state_in|
    id = 0
    state_fips_code = ""
    state_name = ""
    lasd = ""
    lasd_translation = ""
    states = []
    fips_to_id = []
    state_to_id = {}
    terminator = ""
    File.open('public/st99_d00a.dat','rb') do |fp|
      fp.each_line do |line|
        record_num = fp.lineno % 6
        #    puts "#{record_num} - \'#{line.strip.delete '\"'}\'"
        case record_num
        when 1
          id = line.strip.to_i
        when 2
          state_fips_code = line.strip.delete '"'
        when 3
          state_name = line.strip.delete '"'
        when 4
          lasd = line.strip.delete '"'
        when 5
          lasd_translation = line.strip.delete '"'
        when 0
          if fp.eof
            terminator = ';'
          else
            terminator = ','
          end
          if(id > 0 && state_to_id[state_fips_code].nil?)
            states[id] = Entity.create({ fips_code: state_fips_code,
                                         entity_name: state_name,
                                         entity_type: 'State',
                                         lasd: lasd,
                                         lasd_translation:lasd_translation
                                       })
            state_to_id[state_fips_code] = states[id]
            print states[id].id.to_s + "\r"
          elsif (id > 0 && !state_to_id[state_fips_code].nil?)
            states[id] = state_to_id[state_fips_code]
          end
        end
      end
    end
    id = old_id = 0
    lat = lng = 0.9
    terminator = ""
    state_name = nil
    starting_point = true;
    sb = []
    print "Reading........\r"
    File.open('public/st99_d00.dat','rb') do |fp|
      fp.each_line do |line|
        if line.strip =~ /^([0-9]+) +([0-9\-+.E]+)  +([0-9\-+.E]+)$/
          id = $1.to_i
          lng = $2.to_f
          lat = $3.to_f
          starting_point = true;
        elsif line.strip =~ /^([0-9\-\+.E]+)  +([0-9\-+.E]+)$/
          lng = $1.to_f
          lat = $2.to_f
        elsif line.strip !~ /^(END|-99999)$/
#          puts '"' + line.strip + '"'
          exit
        end
        unless state_name == states[id].entity_name
          state_name = states[id].entity_name
          puts state_name
        end
        EntityBoundary.create({ entity_id: states[id].id,
                                starting_point: starting_point,
                                lat: lat,
                                lng: lng
                              })
        starting_point = false;
      end
    end
  end


  desc 'Import county data from the census'
  task :county, [:county_in] => :environment do |tsk, _county_in|
    id = 0
    state_fips_code = ""
    county_fips_code = ""
    state_to_id = {}
    county_name = ""
    lasd = ""
    lasd_translation = ""
    counties = []
    fips_to_id = {}
    terminator = ""
    File.open('public/co99_d00a.dat','rb') do |fp|
      fp.each_line do |line|
        record_num = fp.lineno % 7
        #    puts "#{record_num} - \'#{line.strip.delete '\"'}\'"
        case record_num
        when 1
          id = line.strip.to_i
        when 2
          state_fips_code = line.strip.delete '"'
          unless state_to_id[state_fips_code]
            state_to_id[state_fips_code] = Entity.find_by_fips_code(state_fips_code)
          end
        when 3
          county_fips_code = line.strip.delete '"'
        when 4
          county_name = line.strip.delete '"'
        when 5
          lasd = line.strip.delete '"'
        when 6
          lasd_translation = line.strip.delete '"'
        when 0
          if fp.eof
            terminator = ';'
          else
            terminator = ','
          end
          if(id > 0 && fips_to_id[state_fips_code.to_s + county_fips_code.to_s].nil?)
            counties[id] = Entity.create({ entity_parent_id: state_to_id[state_fips_code].id,
                                           fips_code: county_fips_code,
                                           entity_name: county_name,
                                           entity_type: 'County',
                                           lasd: lasd,
                                           lasd_translation: lasd_translation
                                         })
            fips_to_id[state_fips_code.to_s + county_fips_code.to_s] = counties[id]
          elsif (id > 0 && !fips_to_id[state_fips_code.to_s + county_fips_code.to_s].nil?)
            counties[id] = fips_to_id[state_fips_code.to_s + county_fips_code.to_s]
          end
        end
      end
    end

    id = 0
    lat = lng = 0.9
    terminator = ""
    starting_point = true;
    entity_boundaries = []
    entity_boundaries_raw = []
    created_at = updated_at = Time.now.in_time_zone('UTC')
    print "Reading........\r"
    File.open('public/co99_d00.dat','rb') do |fp|
      fp.each_line do |line|
        if line.strip =~ /^([0-9]+) +([0-9\-+.E]+)  +([0-9\-+.E]+)$/
          id = $1.to_i
          lng = $2.to_f
          lat = $3.to_f
          starting_point = true;
          unless entity_boundaries_raw.empty?
            sql = 'insert into entity_boundaries (entity_id,starting_point,lat,lng,created_at, updated_at) values '
            sql = sql + entity_boundaries_raw.collect do |b|
              "(#{b[0]},#{b[1]},#{b[2]},#{b[3]},'#{b[4]}','#{b[5]}')"
            end.join(',')
            conn = EntityBoundary.connection
            conn.execute(sql)
            entity_boundaries_raw = []
          end
        elsif line.strip =~ /^([0-9\-\+.E]+)  +([0-9\-+.E]+)$/
          lng = $1.to_f
          lat = $2.to_f
        elsif line.strip !~ /^(END|-99999)$/
          #      puts '"' + line.strip + '"'
          exit
        end
        if counties[id].nil?
          puts "no county for id = #{id}"
        end
        entity_boundaries_raw << [counties[id].id,
                                  starting_point,
                                  lat,
                                  lng,
                                  created_at,
                                  updated_at
                                 ]
        starting_point = false;
      end
    end
  end
end
