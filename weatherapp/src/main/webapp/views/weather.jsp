<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Weather Application</title>
<style>
.container {
	padding: 20px;
	font-family: Arial, sans-serif;
}

.search-bar {
	display: flex;
	justify-content: center;
	margin-bottom: 20px;
}

.search-bar input {
	padding: 10px;
	font-size: 1rem;
	border-radius: 5px;
	border: 1px solid #ccc;
	width: 300px;
}

.search-bar button {
	padding: 10px 20px;
	background-color: #ff9800;
	color: white;
	border: none;
	border-radius: 5px;
	cursor: pointer;
	font-size: 1rem;
	margin-left: 10px;
}

.search-bar button:hover {
	background-color: #e65100;
}

.section {
	margin-top: 20px;
}

.temperature {
	font-size: 2rem;
	font-weight: bold;
}

.icon img {
	width: 100px;
	height: 100px;
}

.grid {
	display: flex;
	justify-content: space-between;
}

.grid-item {
	flex: 1;
	margin-right: 10px;
}

.back-button {
	color: #ff9800;
	text-decoration: none;
	font-size: 1.2rem;
}

.back-button:hover {
	text-decoration: underline;
}

.error-message {
	color: red;
	font-size: 1.2rem;
	text-align: center;
}
</style>
</head>
<body>
	<div class="container">
		<!-- Search Bar -->
		<div class="search-bar">
			<form action="/getWeatherbyname" method="post">
				<input type="text" name="city" placeholder="Enter city name"
					required>
				<button type="submit">Search</button>
			</form>
		</div>

		<!-- Weather Information Section -->
		<div class="section">
			<%
			com.weather.model.Weather weather = (com.weather.model.Weather) request.getAttribute("weather");
			if (weather != null) {
			%>
			<h2><%=weather.getCityName()%></h2>
			<div class="temperature">
				<%=weather.getTemperature()%>°C
			</div>
			<div class="icon">
				<img
					src="http://openweathermap.org/img/wn/<%=weather.getIcon()%>@2x.png"
					alt="Weather Icon">
				<p>
					<strong><%=weather.getDescription()%></strong>
				</p>
			</div>

			<!-- Additional Weather Details -->
			<h3>Details</h3>
			<div class="grid">
				<div class="grid-item">
					<h4>Feels Like</h4>
					<p><%=weather.getFeelsLike()%>°C
					</p>
				</div>
				<div class="grid-item">
					<h4>Min Temp</h4>
					<p><%=weather.getTempMin()%>°C
					</p>
				</div>
				<div class="grid-item">
					<h4>Max Temp</h4>
					<p><%=weather.getTempMax()%>°C
					</p>
				</div>
				<div class="grid-item">
					<h4>Pressure</h4>
					<p><%=weather.getPressure()%>
						hPa
					</p>
				</div>
				<div class="grid-item">
					<h4>Humidity</h4>
					<p><%=weather.getHumidity()%>
						%
					</p>
				</div>
				<div class="grid-item">
					<h4>Wind Speed</h4>
					<p><%=weather.getWindSpeed()%>
						m/s
					</p>
				</div>
				<div class="grid-item">
					<h4>Wind Gust</h4>
					<p><%=weather.getWindGust()%>
						m/s
					</p>
				</div>
				<div class="grid-item">
					<h4>Visibility</h4>
					<p><%=weather.getVisibility() / 1000.0%>
						km
					</p>
					<!-- Convert meters to kilometers -->
				</div>
				<div class="grid-item">
					<h4>Cloud Coverage</h4>
					<p><%=weather.getCloudCoverage()%>
						%
					</p>
				</div>

				<!-- Sunrise and Sunset -->
				<div class="grid-item">
					<h4>Sunrise</h4>
					<%
					java.util.Date sunriseDate = new java.util.Date(weather.getSunrise() * 1000L);
					out.print(new java.text.SimpleDateFormat("HH:mm:ss").format(sunriseDate));
					%>
				</div>
				<div class="grid-item">
					<h4>Sunset</h4>
					<%
					java.util.Date sunsetDate = new java.util.Date(weather.getSunset() * 1000L);
					out.print(new java.text.SimpleDateFormat("HH:mm:ss").format(sunsetDate));
					%>
				</div>
			</div>

			<%
			} else {
			%>
			<p class="error-message">No weather data available. Please check
				the city name or try again later.</p>
			<%
			}
			%>
		</div>

		<!-- Back Button -->
		<div class="section" style="text-align: center;">
			<a class="back-button" href="#" onclick="window.history.back();">Back</a>
		</div>
	</div>
</body>
</html>
