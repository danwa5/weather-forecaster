require 'rails_helper'

RSpec.describe FetchWeatherForecast do
  let(:zip_code) { [123, '456'].sample }
  let(:cache) { double }
  let(:api_response) { File.read('spec/fixtures/api_response.json') }
  let(:forecast_data) do
    {
      name: 'Dublin',
      region: 'California',
      country: 'USA',
      current_weather: {
        condition: 'Sunny',
        temp_c: 26.1,
        temp_f: 79
      },
      forecasted_weather: {
        condition: 'Partly cloudy',
        max_temp_c: 25.8,
        max_temp_f: 78.4,
        min_temp_c: 7.3,
        min_temp_f: 45.1
      }
    }
  end

  describe '#call' do
    context 'when cached data is found' do
      it 'returns the cached data' do
        allow(Rails).to receive(:cache).and_return(cache)
        expect(cache).to receive(:read).with(zip_code.to_s).and_return(forecast_data)

        expect_any_instance_of(WeatherApiService).not_to receive(:http_get)

        res = described_class.new(zip_code).call

        expect(res).to be_success
        expect(res.value!).to eq(forecast_data)
      end
    end

    context 'when WeatherApiService call succeeds' do
      it 'caches and returns data' do
        allow(Rails).to receive(:cache).and_return(cache)
        expect(cache).to receive(:read).with(zip_code.to_s).and_return(nil)

        expect_any_instance_of(WeatherApiService).to receive(:http_get)
          .with({ 'q' => zip_code.to_s })
          .and_return(double(code: '200', body: api_response))

        expect_any_instance_of(Api::WeatherForecastPresenter).to receive(:as_json).and_call_original

        expect(cache).to receive(:write)
          .with(zip_code.to_s, forecast_data.merge(cached: true), expires_in: 30.minutes).once

        res = described_class.new(zip_code).call

        expect(res).to be_success
        expect(res.value!).to eq(forecast_data)
      end
    end

    context 'when WeatherApiService call fails' do
      it 'returns a WeatherApiServiceError exception' do
        expect_any_instance_of(WeatherApiService).to receive(:http_get)
          .with({ 'q' => zip_code.to_s })
          .and_return(double(code: '400'))

        res = described_class.new(zip_code).call

        expect(res).to be_failure
        expect(res.exception.class).to eq(Errors::WeatherApiServiceError)
        expect(res.exception.message).to eq("Error fetching weather forecast for #{zip_code} zip/postal code")
      end
    end
  end
end
