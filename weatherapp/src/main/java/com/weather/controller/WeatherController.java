package com.weather.controller;

import com.weather.model.Coordinates;
import com.weather.model.Weather;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.util.UriComponentsBuilder;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

@Controller
public class WeatherController {

    @Value("${weather.api.key}")
    private String apiKey;

    private final RestTemplate restTemplate;
    private final ObjectMapper objectMapper;

    public WeatherController(RestTemplate restTemplate, ObjectMapper objectMapper) {
        this.restTemplate = restTemplate;
        this.objectMapper = objectMapper;
    }

    @GetMapping("/")
    public ModelAndView home() {
        ModelAndView model = new ModelAndView();
        model.addObject(new Coordinates());
        model.setViewName("index");
        return model;
    }

    @PostMapping("/getWeather")
    public ModelAndView getWeather(Coordinates coordinates) {
        // Log the received coordinates
        System.out.println("Received coordinates: " + coordinates);

        // Build the URL to fetch the weather data using non-deprecated method
        String url = buildWeatherUrl(coordinates);

        // Use RestTemplate to fetch the weather data
        String response = restTemplate.getForObject(url, String.class);

        // Parse the JSON response
        Weather weather = parseWeatherData(response);

        // Create the ModelAndView and set the attributes
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("weather", weather);
        modelAndView.addObject("coordinates", coordinates);
        modelAndView.setViewName("weather"); // Return to the weather view

        return modelAndView;
    }

    private String buildWeatherUrl(Coordinates coordinates) {
        return UriComponentsBuilder.fromUriString("https://api.openweathermap.org/data/2.5/weather")
                .queryParam("lat", coordinates.getLatittude())
                .queryParam("lon", coordinates.getLongitude())
                .queryParam("appid", apiKey)
                .queryParam("units", "metric") // Temperature in Celsius
                .toUriString();
    }

    private Weather parseWeatherData(String jsonResponse) {
        try {
            // Use Jackson ObjectMapper to parse the JSON response
            JsonNode responseJson = objectMapper.readTree(jsonResponse);

            Weather weather = new Weather();
            weather.setCityName(responseJson.get("name").asText());
            weather.setDescription(responseJson.get("weather").get(0).get("description").asText());
            weather.setIcon(responseJson.get("weather").get(0).get("icon").asText());

            JsonNode main = responseJson.get("main");
            weather.setTemperature(main.get("temp").asDouble());
            weather.setFeelsLike(main.get("feels_like").asDouble());
            weather.setTempMin(main.get("temp_min").asDouble());
            weather.setTempMax(main.get("temp_max").asDouble());
            weather.setPressure(main.get("pressure").asInt());
            weather.setHumidity(main.get("humidity").asInt());

            JsonNode wind = responseJson.get("wind");
            weather.setWindSpeed(wind.get("speed").asDouble());
            weather.setWindDirection(wind.get("deg").asInt());
            weather.setWindGust(wind.has("gust") ? wind.get("gust").asDouble() : 0); // Default to 0 if not present

            weather.setVisibility(responseJson.get("visibility").asInt());

            JsonNode clouds = responseJson.get("clouds");
            weather.setCloudCoverage(clouds.get("all").asInt());

            JsonNode sys = responseJson.get("sys");
            weather.setSunrise(sys.get("sunrise").asInt());
            weather.setSunset(sys.get("sunset").asInt());

            return weather;
        } catch (Exception e) {
            e.printStackTrace();
            return null;  // Return null if there is an error parsing the data
        }
    }
    
    @PostMapping("/getWeatherbyname")
    public ModelAndView getWeatherbycityname(String city) {
        // Log the received city name
        System.out.println("Received city name: " + city);

        // Build the URL to fetch the weather data using the city name
        String url = buildWeatherUrl(city);

        // Use RestTemplate to fetch the weather data
        String response = restTemplate.getForObject(url, String.class);

        // Parse the JSON response
        Weather weather = parseWeatherData(response);

        // Create the ModelAndView and set the attributes
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("weather", weather);
        modelAndView.setViewName("weather"); // Return to the weather view

        return modelAndView;
    }

    private String buildWeatherUrl(String cityName) {
        return UriComponentsBuilder.fromUriString("https://api.openweathermap.org/data/2.5/weather")
                .queryParam("q", cityName) // Add the city name to the query parameters
                .queryParam("appid", apiKey) // Your OpenWeather API key
                .queryParam("units", "metric") // Temperature in Celsius
                .toUriString();
    }
}
