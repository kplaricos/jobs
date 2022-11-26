require_relative '../lib/level_base'

module Drivy
    class Level5 < LevelBase
        def initialize
            parse_inputs(File.expand_path('../data/input.json', __FILE__))
        end

        def to_output
            result = car_rents.map do |rent|
                rent_row = rent.output_format { |car_rent| discount_pricing(car_rent) }
                owner_fees, drivy_fees = option_prices(rent.options, rent.days_between)

                actions = rental_actions(
                    rent_row,
                    compute_commission(rent_row[:price], rent.days_between),
                    owner_fees, drivy_fees
                )
                
                { id: rent_row[:id], options: rent.options, actions: actions }
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

        def rental_actions(rent_row, commissions, owner_fees, drivy_fees)
            total_price = rent_row[:price] + owner_fees + drivy_fees
            owner_total = (rent_row[:price] - rent_row[:price] * 0.3).to_i + owner_fees

            [
                ActionStruct.new('driver', 'debit', total_price).to_h,
                ActionStruct.new('owner', 'credit', owner_total).to_h,
                ActionStruct.new('insurance', 'credit', commissions[:insurance_fee]).to_h,
                ActionStruct.new('assistance', 'credit', commissions[:assistance_fee]).to_h,
                ActionStruct.new('drivy', 'credit', commissions[:drivy_fee] + drivy_fees).to_h,
            ]
        end

        def option_prices(options, days)
            owner_fees = 0;
            drivy_fees = 0;

            owner_fees += 500 * days if options.include? 'gps'
            owner_fees += 200 * days if options.include? 'baby_seat'
            drivy_fees = 1000 * days if options.include? 'additional_insurance'

            [owner_fees, drivy_fees]
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

instance = Drivy::Level5.new
instance.to_output