require_relative '../lib/level_base'

module Drivy
    class Level3 < LevelBase
        def initialize
            parse_inputs(File.expand_path('../data/input.json', __FILE__))
        end

        def to_output
            result = car_rents.map do |rent|
                rent_row = rent.output_format { |car_rent| discount_pricing(car_rent) }
                rent_row[:commission] = compute_commission(rent_row[:price], rent.days_between)

                rent_row
            end

            output = { rentals: result.flatten }

            File.write(File.expand_path('../data/output.json', __FILE__), output.to_json)
        end

        private

        def discount_pricing(car_rent)
            time_component(car_rent) + car_rent.distance_component
        end

        def compute_commission(price, days)
            comm_price = price * 0.3
            insurance_fee, assistance_fee = comm_price * 0.5, days * 100
            drivy_fee = comm_price - (insurance_fee + assistance_fee)

            {
                insurance_fee: insurance_fee.to_i,
                assistance_fee: assistance_fee.to_i,
                drivy_fee: drivy_fee.to_i
            }
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

instance = Drivy::Level3.new
instance.to_output