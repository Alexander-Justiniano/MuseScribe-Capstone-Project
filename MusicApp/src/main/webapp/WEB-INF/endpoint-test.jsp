<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- c:out ; c:forEach etc. --> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- Formatting (dates) --> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"  %>
<!-- form:form -->
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!-- for rendering errors on PUT routes -->
<%@ page isErrorPage="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>MuseScribe - Music Transcription</title>
	<meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- Include ABC.js for rendering ABC notation -->
    <script src="https://cdn.jsdelivr.net/npm/abcjs@6.0.0/dist/abcjs-basic-min.js"></script>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
</head>
<body>
	<div class="container">
	    <h1>Music Transcription Upload Test</h1>
	
	    <!-- Loading indicator shown while processing requests -->
	    <div id="loading" style="display:none;">
	        <p>Processing... Please wait.</p>
	        <img src="https://i.gifer.com/ZZ5H.gif" alt="Loading...">
	    </div>
		
		
		<h2>Upload an audio for transcribing to ABC notation</h2>
		<p>when this action occurs on the mt3 flask server, a midi file is created and can be used with the fetch data button to test endpoint and midi to abc notation flow.</p>
	    <!-- Form to upload the audio file for transcription -->
	    <form id="uploadForm" action="" method="POST" enctype="multipart/form-data">
	        <input type="file" id="audioFile" accept=".mp3, .wav" required>
	        <button type="submit" style="background:blue; color:white; padding:.5rem 1rem;border:none;border-radius:.5rem;">Transcribe</button>
	    </form>
	    
		<h4>If you have NOT already uploaded and processed an audio file, the following wont work.</h4>
	    <!-- Button to fetch test data from the /test-data endpoint -->
	    <button id="fetchDataBtn" style="background:blue; color:white; padding:.5rem 1rem;border:none;border-radius:.5rem;">Fetch Data</button>
	    
	    <!-- Container where ABC.js will render the sheet music -->
	    <div id="music-sheet"></div>
	</div>
    <script type="text/javascript">
		
		const ENDPOINT_HOST = "https://secure-darling-minnow.ngrok-free.app/"
		
        window.onload = function() {
            // Event listener for form submission (upload audio file)
            document.getElementById('uploadForm').addEventListener('submit', function(e) {
                e.preventDefault(); // Prevent the default form submission (page reload)

                var fileInput = document.getElementById('audioFile');
                var formData = new FormData();
                formData.append('file', fileInput.files[0]);

                // Show loading spinner and hide the music sheet area during processing
                document.getElementById('loading').style.display = 'block';
                document.getElementById('music-sheet').style.display = 'none';

                // Make POST request to the upload endpoint
                fetch(`${ENDPOINT_HOST}/upload-audio`, {
                    method: 'POST',
                    body: formData
                })
                .then(response => response.json()) // Parse the JSON response
                .then(data => {
                    // Hide loading spinner and show the music sheet area
                    document.getElementById('loading').style.display = 'none';
                    document.getElementById('music-sheet').style.display = 'block';

                    // Check for ABC notation data in the response under transcription.abc_notation
                    if (data.transcription && data.transcription.abc_notation) {
                        var abcString = data.transcription.abc_notation;
                        // Render the ABC notation into sheet music using ABC.js
                        ABCJS.renderAbc("music-sheet", abcString);
                    } else {
                        alert("Transcription failed: " + data.error);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    document.getElementById('loading').style.display = 'none';
                });
            });

            // Event listener for the "Fetch Data" button
            document.getElementById('fetchDataBtn').addEventListener('click', function(e) {
                e.preventDefault(); // Prevent any default action

                // Show loading spinner and hide music sheet area during processing
                document.getElementById('loading').style.display = 'block';
                document.getElementById('music-sheet').style.display = 'none';

                // Make a GET request to the /test-data endpoint
                fetch("https://secure-darling-minnow.ngrok-free.app/test-data", {
                    method: 'GET',
					headers: {
					     "ngrok-skip-browser-warning": "true"
					}
                })
                .then(response => response.json()) // Parse JSON response
                .then(data => {
                    // Hide loading spinner and show music sheet area
                    document.getElementById('loading').style.display = 'none';
                    document.getElementById('music-sheet').style.display = 'block';

                    // Check if the returned JSON contains ABC notation
                    if (data.transcription && data.transcription.abc_notation) {
                        var abcString = data.transcription.abc_notation;
                        // Render the ABC notation using ABC.js
                        ABCJS.renderAbc("music-sheet", abcString);
                    } else {
                        alert("Failed to fetch test data: " + data.error);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    document.getElementById('loading').style.display = 'none';
                });
            });
        }
    </script>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>
