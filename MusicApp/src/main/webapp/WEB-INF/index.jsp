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
    <script src="https://cdn.jsdelivr.net/npm/abcjs@6.0.0/dist/abcjs-basic-min.js"></script>
</head>
<body>
    <h1>Music Transcription</h1>

    <div id="loading" style="display:none;">
        <p>Transcribing... Please wait.</p>
        <img src="https://i.gifer.com/ZZ5H.gif" alt="Loading...">
    </div>

    <form id="uploadForm" action="${pageContext.request.contextPath}/upload-audio" method="post" enctype="multipart/form-data">
        <input type="file" id="audioFile" accept=".mp3, .wav" required>
        <button type="submit">Upload and Transcribe</button>
    </form>
    
    <div id="music-sheet"></div>
      
    <script type="text/javascript">
		window.onload = function() {
		          // Attach an event listener to the form for when it's submitted.
		          document.getElementById('uploadForm').addEventListener('submit', function(e) {
		              // Prevent the default form submission behavior (page reload)
		              e.preventDefault();

		              // Retrieve the selected file from the file input element
		              var fileInput = document.getElementById('audioFile');
		              var formData = new FormData();
		              formData.append('file', fileInput.files[0]);

		              // Show the loading spinner and hide the music sheet area during processing
		              document.getElementById('loading').style.display = 'block';
		              document.getElementById('music-sheet').style.display = 'none';

		              // Use the Fetch API to send a POST request to the upload endpoint
		              fetch(document.getElementById('uploadForm').action, {
		                  method: 'POST',
		                  body: formData
		              })
		              .then(response => response.json()) // Parse the JSON response
		              .then(data => {
		                  // Hide the loading spinner and display the music sheet container
		                  document.getElementById('loading').style.display = 'none';
		                  document.getElementById('music-sheet').style.display = 'block';

		                  // Check if the response contains the ABC notation under transcription2.abc_notation
		                  if (data.transcription2 && data.transcription2.abc_notation) {
		                      // Directly assign the returned ABC notation string
		                      var abcString = data.transcription2.abc_notation;
		                      // Render the ABC notation into sheet music using ABC.js
		                      ABCJS.renderAbc("music-sheet", abcString);
		                  } else {
		                      // Alert the user if transcription failed
		                      alert("Transcription failed: " + data.error);
		                  }
		              })
		              .catch(error => {
		                  // Log any errors to the console and hide the loading spinner
		                  console.error('Error:', error);
		                  document.getElementById('loading').style.display = 'none';
		              });
		          });
		      }
    </script>

</body>
</html>
