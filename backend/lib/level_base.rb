require 'json'
require_relative 'structs'
require_relative 'car_rental'

module Drivy
    class LevelBase
        attr_accessor :inputs, :car_rents

        private

        def parse_inputs(path)
            content = File.read path
            @inputs = JSON.parse content

            cars = Array.new inputs['cars']
            rentals = Array.new inputs['rentals']
            options = Array.new inputs['options'] || []
            @car_rents = Array.new

            rentals.each do |rental|
                car = cars.find { |car| car['id'] === rental['car_id'] }
                rent_options = options.filter { |option| option['rental_id'] === rental['id'] }
                args = RentalStruct.new(
                    rental['id'],
                    car['price_per_day'],
                    car['price_per_km'],
                    rental['start_date'],
                    rental['end_date'],
                    rental['distance'],
                    rent_options.map { |option| option['type'] }
                )

                car_rents.push(CarRental.new args)
            end
        end
    end
end