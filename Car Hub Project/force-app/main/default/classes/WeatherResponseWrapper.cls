public class WeatherResponseWrapper {
    public Request request { get; set; }
    public Location location { get; set; }
    public Current current { get; set; }

    public WeatherResponseWrapper() {}

    // ------------------ Parse helper ------------------
    public static WeatherResponseWrapper parse(String json) {
        if (String.isBlank(json)) return null;
        JSONParser parser = System.JSON.createParser(json);
        WeatherResponseWrapper wrapper = new WeatherResponseWrapper();

        while (parser.nextToken() != System.JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                String fld = parser.getText();
                if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                    if (fld == 'request') {
                        wrapper.request = new Request(parser);
                    } else if (fld == 'location') {
                        wrapper.location = new Location(parser);
                    } else if (fld == 'current') {
                        wrapper.current = new Current(parser);
                    } else {
                        System.debug(LoggingLevel.WARN, 'Root consuming unrecognized property: ' + fld);
                        consumeObject(parser);
                    }
                }
            }
        }
        return wrapper;
    }

    // Optional: reserialize to JSON
    public String toJson() {
        return JSON.serializePretty(this);
    }

    // ------------------ Request ------------------
    public class Request {
        public String type { get; set; }
        public String query { get; set; }
        public String language { get; set; }
        public String unit { get; set; }

        public Request() {}

        public Request(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'type') {
                            type = parser.getText();
                        } else if (text == 'query') {
                            query = parser.getText();
                        } else if (text == 'language') {
                            language = parser.getText();
                        } else if (text == 'unit') {
                            unit = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Request consuming unrecognized property: ' + text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }

    // ------------------ Location ------------------
    public class Location {
        public String name { get; set; }
        public String country { get; set; }
        public String region { get; set; }
        public String lat { get; set; }
        public String lon { get; set; }
        public String timezone_id { get; set; }
        public String localtime { get; set; }
        public Long localtime_epoch { get; set; }
        public String utc_offset { get; set; }

        public Location() {}

        public Location(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'name') {
                            name = parser.getText();
                        } else if (text == 'country') {
                            country = parser.getText();
                        } else if (text == 'region') {
                            region = parser.getText();
                        } else if (text == 'lat') {
                            lat = parser.getText();
                        } else if (text == 'lon') {
                            lon = parser.getText();
                        } else if (text == 'timezone_id') {
                            timezone_id = parser.getText();
                        } else if (text == 'localtime') {
                            localtime = parser.getText();
                        } else if (text == 'localtime_epoch') {
                            // parser.getText() returns string representation, prefer getLongValue() when available
                            try {
                                localtime_epoch = parser.getLongValue();
                            } catch (Exception e) {
                                // fallback if parser cannot provide numeric directly
                                localtime_epoch = Long.valueOf(parser.getText());
                            }
                        } else if (text == 'utc_offset') {
                            utc_offset = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Location consuming unrecognized property: ' + text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }

    // ------------------ Current ------------------
    public class Current {
        public String observation_time { get; set; }
        public Integer temperature { get; set; }
        public Integer weather_code { get; set; }
        public List<String> weather_icons { get; set; }
        public List<String> weather_descriptions { get; set; }
        public Astro astro { get; set; }
        // air_quality contains hyphenated keys (e.g. "us-epa-index") - use Map
        public Map<String, String> air_quality { get; set; }

        public Integer wind_speed { get; set; }
        public Integer wind_degree { get; set; }
        public String wind_dir { get; set; }
        public Integer pressure { get; set; }
        public Decimal precip { get; set; }
        public Integer humidity { get; set; }
        public Integer cloudcover { get; set; }
        public Integer feelslike { get; set; }
        public Integer uv_index { get; set; }
        public Integer visibility { get; set; }
        public String is_day { get; set; }

        public Current() {
            weather_icons = new List<String>();
            weather_descriptions = new List<String>();
            air_quality = new Map<String, String>();
        }

        public Current(JSONParser parser) {
            weather_icons = new List<String>();
            weather_descriptions = new List<String>();
            air_quality = new Map<String, String>();

            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'observation_time') {
                            observation_time = parser.getText();
                        } else if (text == 'temperature') {
                            try {
                                temperature = parser.getIntegerValue();
                            } catch (Exception e) {
                                temperature = Integer.valueOf(parser.getText());
                            }
                        } else if (text == 'weather_code') {
                            try {
                                weather_code = parser.getIntegerValue();
                            } catch (Exception e) {
                                weather_code = Integer.valueOf(parser.getText());
                            }
                        } else if (text == 'weather_icons') {
                            // parse array of strings
                            if (parser.getCurrentToken() == System.JSONToken.START_ARRAY) {
                                while (parser.nextToken() != System.JSONToken.END_ARRAY) {
                                    if (parser.getCurrentToken() == System.JSONToken.VALUE_STRING) {
                                        weather_icons.add(parser.getText());
                                    } else {
                                        // skip any unexpected token
                                        consumeObject(parser);
                                    }
                                }
                            } else {
                                consumeArray(parser);
                            }
                        } else if (text == 'weather_descriptions') {
                            if (parser.getCurrentToken() == System.JSONToken.START_ARRAY) {
                                while (parser.nextToken() != System.JSONToken.END_ARRAY) {
                                    if (parser.getCurrentToken() == System.JSONToken.VALUE_STRING) {
                                        weather_descriptions.add(parser.getText());
                                    } else {
                                        consumeObject(parser);
                                    }
                                }
                            } else {
                                consumeArray(parser);
                            }
                        } else if (text == 'astro') {
                            astro = new Astro(parser);
                        } else if (text == 'air_quality') {
                            // parse as object into map to preserve hyphenated keys
                            if (parser.getCurrentToken() == System.JSONToken.START_OBJECT) {
                                while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                                    if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                                        String ak = parser.getText();
                                        if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                                            // read value as text to preserve formatting
                                            air_quality.put(ak, parser.getText());
                                        }
                                    }
                                }
                            } else {
                                consumeObject(parser);
                            }
                        } else if (text == 'wind_speed') {
                            try {
                                wind_speed = parser.getIntegerValue();
                            } catch (Exception e) {
                                wind_speed = Integer.valueOf(parser.getText());
                            }
                        } else if (text == 'wind_degree') {
                            try {
                                wind_degree = parser.getIntegerValue();
                            } catch (Exception e) {
                                wind_degree = Integer.valueOf(parser.getText());
                            }
                        } else if (text == 'wind_dir') {
                            wind_dir = parser.getText();
                        } else if (text == 'pressure') {
                            try {
                                pressure = parser.getIntegerValue();
                            } catch (Exception e) {
                                pressure = Integer.valueOf(parser.getText());
                            }
                        } else if (text == 'precip') {
                            try {
                                precip = parser.getDecimalValue();
                            } catch (Exception e) {
                                precip = Decimal.valueOf(parser.getText());
                            }
                        } else if (text == 'humidity') {
                            try {
                                humidity = parser.getIntegerValue();
                            } catch (Exception e) {
                                humidity = Integer.valueOf(parser.getText());
                            }
                        } else if (text == 'cloudcover') {
                            try {
                                cloudcover = parser.getIntegerValue();
                            } catch (Exception e) {
                                cloudcover = Integer.valueOf(parser.getText());
                            }
                        } else if (text == 'feelslike') {
                            try {
                                feelslike = parser.getIntegerValue();
                            } catch (Exception e) {
                                feelslike = Integer.valueOf(parser.getText());
                            }
                        } else if (text == 'uv_index') {
                            try {
                                uv_index = parser.getIntegerValue();
                            } catch (Exception e) {
                                uv_index = Integer.valueOf(parser.getText());
                            }
                        } else if (text == 'visibility') {
                            try {
                                visibility = parser.getIntegerValue();
                            } catch (Exception e) {
                                visibility = Integer.valueOf(parser.getText());
                            }
                        } else if (text == 'is_day') {
                            is_day = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Current consuming unrecognized property: ' + text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }

        // Helper methods
        public String getPrimaryWeatherIcon() {
            if (weather_icons == null || weather_icons.isEmpty()) return null;
            return weather_icons[0];
        }

        public String getPrimaryWeatherDescription() {
            if (weather_descriptions == null || weather_descriptions.isEmpty()) return null;
            return weather_descriptions[0];
        }

        public String getAirQualityValue(String key) {
            if (air_quality == null) return null;
            return air_quality.get(key);
        }

        public String getWeatherDescriptionsAsString() {
            if (weather_descriptions == null || weather_descriptions.isEmpty()) return '';
            return String.join(weather_descriptions, ', ');
        }
    }

    // ------------------ Astro ------------------
    public class Astro {
        public String sunrise { get; set; }
        public String sunset { get; set; }
        public String moonrise { get; set; }
        public String moonset { get; set; }
        public String moon_phase { get; set; }
        public Integer moon_illumination { get; set; }

        public Astro() {}

        public Astro(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'sunrise') {
                            sunrise = parser.getText();
                        } else if (text == 'sunset') {
                            sunset = parser.getText();
                        } else if (text == 'moonrise') {
                            moonrise = parser.getText();
                        } else if (text == 'moonset') {
                            moonset = parser.getText();
                        } else if (text == 'moon_phase') {
                            moon_phase = parser.getText();
                        } else if (text == 'moon_illumination') {
                            try {
                                moon_illumination = parser.getIntegerValue();
                            } catch (Exception e) {
                                moon_illumination = Integer.valueOf(parser.getText());
                            }
                        } else {
                            System.debug(LoggingLevel.WARN, 'Astro consuming unrecognized property: ' + text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }

    // ------------------ Utility skip methods ------------------
    private static void consumeObject(JSONParser parser) {
        if (parser.getCurrentToken() == System.JSONToken.START_OBJECT) {
            Integer depth = 1;
            while (depth > 0 && parser.nextToken() != null) {
                if (parser.getCurrentToken() == System.JSONToken.START_OBJECT) depth++;
                else if (parser.getCurrentToken() == System.JSONToken.END_OBJECT) depth--;
                else if (parser.getCurrentToken() == System.JSONToken.START_ARRAY) {
                    consumeArray(parser);
                }
            }
        } else {
            // advance one token to avoid infinite loop
            parser.nextToken();
        }
    }

    private static void consumeArray(JSONParser parser) {
        if (parser.getCurrentToken() != System.JSONToken.START_ARRAY) return;
        Integer depth = 1;
        while (depth > 0 && parser.nextToken() != null) {
            if (parser.getCurrentToken() == System.JSONToken.START_ARRAY) depth++;
            else if (parser.getCurrentToken() == System.JSONToken.END_ARRAY) depth--;
            else if (parser.getCurrentToken() == System.JSONToken.START_OBJECT) {
                consumeObject(parser);
            }
        }
    }

    // ------------------ Example usage ------------------
    // String json = '<your JSON here>';
    // WeatherResponseWrapper w = WeatherResponseWrapper.parse(json);
    // System.debug('City: ' + w.location.name);
    // System.debug('Temp: ' + w.current.temperature);
    // System.debug('PM2.5: ' + w.current.getAirQualityValue('pm2_5'));
}