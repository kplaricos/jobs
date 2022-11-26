require 'date'

module Drivy
    class CarRental
        attr_accessor :id, :price_per_day, :price_per_km, :start_date, :end_date, :distance

        def initialize(args)
            @id = args.id
            @price_per_day = args.price_per_day
            @price_per_km = args.price_per_km
            @end_date = args.end_date
            @start_date = args.start_date
            @distance = args.distance
        end

        def output_format(&block)
            formatted_price = block.call self if block_given?

            {
                id: id,
                price: formatted_price || time_component + distance_component
            }
        end

        def days_between
            (Date.parse(end_date) - Date.parse(start_date)).to_i + 1
        end

        def time_component
            price_per_day * days_between
        end

        def distance_component
            distance * price_per_km
        end
    end
end