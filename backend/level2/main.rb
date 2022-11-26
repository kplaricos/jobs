require_relative '../lib/level_base'

module Drivy
    class Level2 < LevelBase
        def initialize
            parse_inputs(File.expand_path('../data/input.json', __FILE__))
        end

        def to_output
            result = car_rents.map do |rent|
                rent.output_format { |car_rent| discount_pricing car_rent }
            end

            output = { rentals: result.flatten }

            File.write(File.expand_path('../data/output.json', __FILE__), output.to_json)
        end

        private

        def discount_pricing(car_rent)
            time_component(car_rent) + car_rent.distance_component
        end

        def time_component(car_rent)
            total = 0

            for nbr in 0...car_rent.days_between do
                if nbr.between? 1, 3
                    total += (car_rent.price_per_day * 0.9).to_i
                elsif nbr.between? 4, 9
                    total += (car_rent.price_per_day * 0.7).to_i
                elsif nbr >= 10
                    total += (car_rent.price_per_day * 0.5).to_i
                else
                    total = car_rent.price_per_day
                end
            end

            total.to_i
        end
    end
end

instance = Drivy::Level2.new
instance.to_output