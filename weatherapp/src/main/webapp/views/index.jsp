<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Weather Information</title>
    <script>
        function setCoordinates() {
            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(function (position) {
                    // Set latitude and longitude to hidden input fields
                    document.getElementById("latitude").value = position.coords.latitude;
                    document.getElementById("longitude").value = position.coords.longitude;

                    // Submit the form after setting coordinates
                    document.getElementById("coordinatesForm").submit();
                }, function (error) {
                    alert("Geolocation failed: " + error.message);
                });
            } else {
                alert("Geolocation is not supported by this browser.");
            }
        }
    </script>
</head>
<body>
    <h1>Weather Information</h1>
    <p>Click the button below to see the current weather in your area:</p>
    
    <!-- Spring form for submitting coordinates -->
    <form:form id="coordinatesForm" method="POST" action="/getWeather" modelAttribute="coordinates">
        <input type="hidden" id="latitude" name="latitude" />
        <input type="hidden" id="longitude" name="longitude" />
        <button type="button" onclick="setCoordinates()">Get Weather</button>
    </form:form>
</body>
</html>
