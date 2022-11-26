module Drivy
    RentalStruct = Struct.new(
        :id, :price_per_day, :price_per_km, :start_date, :end_date, :distance, :options
    )

    ActionStruct = Struct.new(:who, :type, :amount)
end