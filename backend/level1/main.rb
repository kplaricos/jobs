require_relative '../lib/level_base'

module Drivy
    class Level1 < LevelBase

        def initialize
            parse_inputs(File.expand_path('../data/input.json', __FILE__))
        end

        def to_output
            result = car_rents.map { |rent| rent.output_format }.flatten
            output = { rentals: result }

            File.write(File.expand_path('../data/output.json', __FILE__), output.to_json)
        end
    end
end

driver = Drivy::Level1.new
driver.to_output