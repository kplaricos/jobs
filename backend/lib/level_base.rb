require 'json'
require_relative 'rental_struct'
require_relative 'car_rental'

module Drivy
    class LevelBase
        attr_accessor :inputs, :car_rents

        private

        def parse_inputs(path)
            content = File.read path
            @inputs = JSON.parse content

            cars = inputs['cars']
            rentals = Array.new inputs['rentals']
            @car_rents = []

            rentals.each do |rental|
                car = cars.find { |car| car['id'] === rental['car_id'] }
                args = RentalStruct.new(
                    rental['id'],
                    car['price_per_day'],
                    car['price_per_km'],
                    rental['start_date'],
                    rental['end_date'],
                    rental['distance']
                )

                car_rents.push(CarRental.new args)
            end
        end
    end
end