<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- c:out ; c:forEach etc. --> 
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
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
<!--    <link rel="stylesheet" href="/webjars/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="/css/main.css"> 
    <script src="/webjars/bootstrap/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="/js/app.js"></script> -->
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
		
		let hardcodedData = 		{"transcription":{"notes":[{"end_time":0.4,"pitch":62,"start_time":0.01,"velocity":127},{"end_time":0.57,"pitch":64,"start_time":0.34,"velocity":127},{"end_time":0.67,"pitch":71,"start_time":0.51,"velocity":127},{"end_time":0.84,"pitch":71,"start_time":0.76,"velocity":127},{"end_time":0.84,"pitch":72,"start_time":0.67,"velocity":127},{"end_time":1.08,"pitch":69,"start_time":0.84,"velocity":127},{"end_time":1.4,"pitch":71,"start_time":1.01,"velocity":127},{"end_time":1.57,"pitch":64,"start_time":1.34,"velocity":127},{"end_time":1.67,"pitch":71,"start_time":1.51,"velocity":127},{"end_time":2.04,"pitch":71,"start_time":1.67,"velocity":127},{"end_time":2.16,"pitch":69,"start_time":2.0,"velocity":127},{"end_time":2.33,"pitch":71,"start_time":2.16,"velocity":127},{"end_time":2.5,"pitch":74,"start_time":2.33,"velocity":127},{"end_time":2.66,"pitch":71,"start_time":2.5,"velocity":127},{"end_time":2.83,"pitch":69,"start_time":2.66,"velocity":127},{"end_time":3.0,"pitch":67,"start_time":2.83,"velocity":127},{"end_time":3.16,"pitch":66,"start_time":3.0,"velocity":127},{"end_time":3.33,"pitch":62,"start_time":3.16,"velocity":127},{"end_time":3.5,"pitch":69,"start_time":3.33,"velocity":127},{"end_time":3.66,"pitch":62,"start_time":3.5,"velocity":127},{"end_time":3.83,"pitch":71,"start_time":3.66,"velocity":127},{"end_time":4.0,"pitch":62,"start_time":3.83,"velocity":127},{"end_time":4.33,"pitch":69,"start_time":4.0,"velocity":127},{"end_time":4.39,"pitch":62,"start_time":4.17,"velocity":127},{"end_time":4.57,"pitch":66,"start_time":4.33,"velocity":127},{"end_time":4.66,"pitch":62,"start_time":4.5,"velocity":127},{"end_time":4.89,"pitch":69,"start_time":4.66,"velocity":127},{"end_time":5.06,"pitch":62,"start_time":4.83,"velocity":127},{"end_time":5.18,"pitch":74,"start_time":5.0,"velocity":127},{"end_time":5.38,"pitch":69,"start_time":5.16,"velocity":127},{"end_time":5.56,"pitch":66,"start_time":5.33,"velocity":127},{"end_time":5.71,"pitch":62,"start_time":5.5,"velocity":127},{"end_time":5.9,"pitch":64,"start_time":5.66,"velocity":127},{"end_time":5.92,"pitch":71,"start_time":5.83,"velocity":127},{"end_time":6.170000000000001,"pitch":71,"start_time":6.0,"velocity":127},{"end_time":6.390000000000001,"pitch":69,"start_time":6.170000000000001,"velocity":127},{"end_time":6.710000000000001,"pitch":71,"start_time":6.340000000000001,"velocity":127},{"end_time":6.9,"pitch":64,"start_time":6.670000000000001,"velocity":127},{"end_time":6.920000000000001,"pitch":71,"start_time":6.840000000000001,"velocity":127},{"end_time":7.370000000000001,"pitch":71,"start_time":7.010000000000001,"velocity":127},{"end_time":7.5600000000000005,"pitch":69,"start_time":7.340000000000001,"velocity":127},{"end_time":7.73,"pitch":71,"start_time":7.500000000000001,"velocity":127},{"end_time":7.880000000000001,"pitch":74,"start_time":7.670000000000001,"velocity":127},{"end_time":8.040000000000001,"pitch":76,"start_time":7.840000000000001,"velocity":127},{"end_time":8.19,"pitch":78,"start_time":8.0,"velocity":127},{"end_time":8.33,"pitch":79,"start_time":8.17,"velocity":127},{"end_time":8.5,"pitch":81,"start_time":8.33,"velocity":127},{"end_time":8.67,"pitch":78,"start_time":8.5,"velocity":127},{"end_time":8.83,"pitch":76,"start_time":8.67,"velocity":127},{"end_time":9.0,"pitch":73,"start_time":8.83,"velocity":127},{"end_time":9.17,"pitch":74,"start_time":9.0,"velocity":127},{"end_time":9.33,"pitch":71,"start_time":9.17,"velocity":127},{"end_time":9.5,"pitch":69,"start_time":9.33,"velocity":127},{"end_time":9.67,"pitch":66,"start_time":9.5,"velocity":127},{"end_time":9.83,"pitch":62,"start_time":9.67,"velocity":127},{"end_time":10.0,"pitch":64,"start_time":9.83,"velocity":127},{"end_time":10.17,"pitch":66,"start_time":10.0,"velocity":127},{"end_time":10.34,"pitch":62,"start_time":10.17,"velocity":127},{"end_time":10.67,"pitch":64,"start_time":10.34,"velocity":127},{"end_time":11.01,"pitch":62,"start_time":10.67,"velocity":127},{"end_time":11.17,"pitch":64,"start_time":11.01,"velocity":127},{"end_time":11.34,"pitch":71,"start_time":11.17,"velocity":127},{"end_time":11.42,"pitch":72,"start_time":11.34,"velocity":127},{"end_time":11.5,"pitch":71,"start_time":11.42,"velocity":127},{"end_time":11.67,"pitch":69,"start_time":11.5,"velocity":127},{"end_time":12.0,"pitch":71,"start_time":11.67,"velocity":127},{"end_time":12.17,"pitch":64,"start_time":12.0,"velocity":127},{"end_time":12.280000000000001,"pitch":71,"start_time":12.17,"velocity":127},{"end_time":12.670000000000002,"pitch":71,"start_time":12.340000000000002,"velocity":127},{"end_time":12.840000000000002,"pitch":69,"start_time":12.670000000000002,"velocity":127},{"end_time":13.000000000000002,"pitch":71,"start_time":12.840000000000002,"velocity":127},{"end_time":13.170000000000002,"pitch":74,"start_time":13.000000000000002,"velocity":127},{"end_time":13.330000000000002,"pitch":71,"start_time":13.170000000000002,"velocity":127},{"end_time":13.500000000000002,"pitch":69,"start_time":13.330000000000002,"velocity":127},{"end_time":13.670000000000002,"pitch":67,"start_time":13.500000000000002,"velocity":127},{"end_time":13.830000000000002,"pitch":66,"start_time":13.670000000000002,"velocity":127},{"end_time":14.000000000000002,"pitch":62,"start_time":13.830000000000002,"velocity":127},{"end_time":14.170000000000002,"pitch":69,"start_time":14.000000000000002,"velocity":127},{"end_time":14.33,"pitch":62,"start_time":14.170000000000002,"velocity":127},{"end_time":14.5,"pitch":71,"start_time":14.33,"velocity":127},{"end_time":14.67,"pitch":62,"start_time":14.5,"velocity":127},{"end_time":14.84,"pitch":69,"start_time":14.67,"velocity":127},{"end_time":15.0,"pitch":62,"start_time":14.84,"velocity":127},{"end_time":15.17,"pitch":66,"start_time":15.0,"velocity":127},{"end_time":15.34,"pitch":62,"start_time":15.17,"velocity":127},{"end_time":15.5,"pitch":69,"start_time":15.34,"velocity":127},{"end_time":15.67,"pitch":62,"start_time":15.5,"velocity":127},{"end_time":15.83,"pitch":74,"start_time":15.67,"velocity":127},{"end_time":16.0,"pitch":69,"start_time":15.83,"velocity":127},{"end_time":16.17,"pitch":66,"start_time":16.0,"velocity":127},{"end_time":16.33,"pitch":62,"start_time":16.17,"velocity":127},{"end_time":16.58,"pitch":64,"start_time":16.33,"velocity":127},{"end_time":16.669999999999998,"pitch":71,"start_time":16.5,"velocity":127},{"end_time":16.83,"pitch":71,"start_time":16.669999999999998,"velocity":127},{"end_time":17.07,"pitch":69,"start_time":16.83,"velocity":127},{"end_time":17.33,"pitch":71,"start_time":17.0,"velocity":127},{"end_time":17.57,"pitch":64,"start_time":17.33,"velocity":127},{"end_time":17.599999999999998,"pitch":71,"start_time":17.5,"velocity":127},{"end_time":18.0,"pitch":71,"start_time":17.669999999999998,"velocity":127},{"end_time":18.23,"pitch":69,"start_time":18.0,"velocity":127},{"end_time":18.34,"pitch":71,"start_time":18.169999999999998,"velocity":127},{"end_time":18.509999999999998,"pitch":74,"start_time":18.34,"velocity":127},{"end_time":18.669999999999998,"pitch":76,"start_time":18.509999999999998,"velocity":127},{"end_time":18.84,"pitch":78,"start_time":18.669999999999998,"velocity":127},{"end_time":19.0,"pitch":79,"start_time":18.84,"velocity":127},{"end_time":19.169999999999998,"pitch":81,"start_time":19.0,"velocity":127},{"end_time":19.34,"pitch":78,"start_time":19.169999999999998,"velocity":127},{"end_time":19.509999999999998,"pitch":76,"start_time":19.34,"velocity":127},{"end_time":19.669999999999998,"pitch":73,"start_time":19.509999999999998,"velocity":127},{"end_time":19.84,"pitch":74,"start_time":19.669999999999998,"velocity":127},{"end_time":20.0,"pitch":71,"start_time":19.84,"velocity":127},{"end_time":20.169999999999998,"pitch":69,"start_time":20.0,"velocity":127},{"end_time":20.34,"pitch":66,"start_time":20.169999999999998,"velocity":127},{"end_time":20.51,"pitch":62,"start_time":20.34,"velocity":127},{"end_time":20.68,"pitch":64,"start_time":20.51,"velocity":127},{"end_time":20.84,"pitch":66,"start_time":20.68,"velocity":127},{"end_time":21.01,"pitch":62,"start_time":20.84,"velocity":127},{"end_time":21.34,"pitch":64,"start_time":21.01,"velocity":127},{"end_time":21.51,"pitch":79,"start_time":21.34,"velocity":127},{"end_time":21.68,"pitch":78,"start_time":21.51,"velocity":127},{"end_time":21.84,"pitch":76,"start_time":21.68,"velocity":127},{"end_time":22.01,"pitch":71,"start_time":21.84,"velocity":127},{"end_time":22.34,"pitch":71,"start_time":22.01,"velocity":127},{"end_time":22.51,"pitch":76,"start_time":22.34,"velocity":127},{"end_time":22.66,"pitch":78,"start_time":22.51,"velocity":127},{"end_time":22.83,"pitch":79,"start_time":22.66,"velocity":127},{"end_time":23.0,"pitch":76,"start_time":22.83,"velocity":127},{"end_time":23.16,"pitch":76,"start_time":23.0,"velocity":127},{"end_time":23.33,"pitch":71,"start_time":23.16,"velocity":127},{"end_time":23.66,"pitch":71,"start_time":23.33,"velocity":127},{"end_time":23.83,"pitch":79,"start_time":23.66,"velocity":127},{"end_time":24.0,"pitch":76,"start_time":23.83,"velocity":127},{"end_time":24.16,"pitch":74,"start_time":24.0,"velocity":127},{"end_time":24.33,"pitch":71,"start_time":24.16,"velocity":127},{"end_time":24.73,"pitch":69,"start_time":24.33,"velocity":127},{"end_time":24.89,"pitch":66,"start_time":24.67,"velocity":127},{"end_time":25.06,"pitch":69,"start_time":24.830000000000002,"velocity":127},{"end_time":25.23,"pitch":62,"start_time":25.0,"velocity":127},{"end_time":25.39,"pitch":69,"start_time":25.17,"velocity":127},{"end_time":25.56,"pitch":66,"start_time":25.34,"velocity":127},{"end_time":25.62,"pitch":69,"start_time":25.5,"velocity":127},{"end_time":26.06,"pitch":69,"start_time":25.67,"velocity":127},{"end_time":26.22,"pitch":66,"start_time":26.0,"velocity":127},{"end_time":26.39,"pitch":69,"start_time":26.17,"velocity":127},{"end_time":26.56,"pitch":74,"start_time":26.34,"velocity":127},{"end_time":26.67,"pitch":76,"start_time":26.5,"velocity":127},{"end_time":26.830000000000002,"pitch":78,"start_time":26.67,"velocity":127},{"end_time":27.0,"pitch":79,"start_time":26.830000000000002,"velocity":127},{"end_time":27.17,"pitch":76,"start_time":27.0,"velocity":127},{"end_time":27.34,"pitch":71,"start_time":27.17,"velocity":127},{"end_time":27.67,"pitch":71,"start_time":27.34,"velocity":127},{"end_time":27.830000000000002,"pitch":76,"start_time":27.67,"velocity":127},{"end_time":28.0,"pitch":71,"start_time":27.830000000000002,"velocity":127},{"end_time":28.17,"pitch":79,"start_time":28.0,"velocity":127},{"end_time":28.330000000000002,"pitch":71,"start_time":28.17,"velocity":127},{"end_time":28.5,"pitch":76,"start_time":28.330000000000002,"velocity":127},{"end_time":28.67,"pitch":71,"start_time":28.5,"velocity":127},{"end_time":29.0,"pitch":71,"start_time":28.67,"velocity":127},{"end_time":29.17,"pitch":74,"start_time":29.0,"velocity":127},{"end_time":29.330000000000002,"pitch":76,"start_time":29.17,"velocity":127},{"end_time":29.5,"pitch":78,"start_time":29.330000000000002,"velocity":127},{"end_time":29.67,"pitch":79,"start_time":29.5,"velocity":127},{"end_time":29.830000000000002,"pitch":81,"start_time":29.67,"velocity":127},{"end_time":30.0,"pitch":78,"start_time":29.830000000000002,"velocity":127},{"end_time":30.17,"pitch":76,"start_time":30.0,"velocity":127},{"end_time":30.330000000000002,"pitch":73,"start_time":30.17,"velocity":127},{"end_time":30.5,"pitch":74,"start_time":30.330000000000002,"velocity":127},{"end_time":30.66,"pitch":71,"start_time":30.5,"velocity":127},{"end_time":30.830000000000002,"pitch":69,"start_time":30.66,"velocity":127},{"end_time":30.990000000000002,"pitch":66,"start_time":30.830000000000002,"velocity":127},{"end_time":31.16,"pitch":62,"start_time":30.990000000000002,"velocity":127},{"end_time":31.330000000000002,"pitch":64,"start_time":31.16,"velocity":127},{"end_time":31.490000000000002,"pitch":66,"start_time":31.330000000000002,"velocity":127},{"end_time":31.66,"pitch":62,"start_time":31.490000000000002,"velocity":127},{"end_time":31.990000000000002,"pitch":64,"start_time":31.66,"velocity":127},{"end_time":32.160000000000004,"pitch":79,"start_time":31.990000000000002,"velocity":127},{"end_time":32.33,"pitch":78,"start_time":32.160000000000004,"velocity":127},{"end_time":32.49,"pitch":76,"start_time":32.33,"velocity":127},{"end_time":32.660000000000004,"pitch":71,"start_time":32.49,"velocity":127},{"end_time":33.0,"pitch":71,"start_time":32.660000000000004,"velocity":127},{"end_time":33.169999999999995,"pitch":76,"start_time":33.0,"velocity":127},{"end_time":33.33,"pitch":78,"start_time":33.169999999999995,"velocity":127},{"end_time":33.5,"pitch":79,"start_time":33.33,"velocity":127},{"end_time":33.669999999999995,"pitch":76,"start_time":33.5,"velocity":127},{"end_time":33.839999999999996,"pitch":76,"start_time":33.669999999999995,"velocity":127},{"end_time":34.0,"pitch":71,"start_time":33.839999999999996,"velocity":127},{"end_time":34.33,"pitch":71,"start_time":34.0,"velocity":127},{"end_time":34.5,"pitch":79,"start_time":34.33,"velocity":127},{"end_time":34.669999999999995,"pitch":76,"start_time":34.5,"velocity":127},{"end_time":34.81,"pitch":74,"start_time":34.669999999999995,"velocity":127},{"end_time":35.050000000000004,"pitch":71,"start_time":34.84,"velocity":127},{"end_time":35.39,"pitch":69,"start_time":35.0,"velocity":127},{"end_time":35.56,"pitch":66,"start_time":35.34,"velocity":127},{"end_time":35.730000000000004,"pitch":69,"start_time":35.5,"velocity":127},{"end_time":35.900000000000006,"pitch":62,"start_time":35.67,"velocity":127},{"end_time":36.06,"pitch":69,"start_time":35.84,"velocity":127},{"end_time":36.230000000000004,"pitch":66,"start_time":36.010000000000005,"velocity":127},{"end_time":36.300000000000004,"pitch":69,"start_time":36.17,"velocity":127},{"end_time":36.72,"pitch":69,"start_time":36.34,"velocity":127},{"end_time":36.86,"pitch":66,"start_time":36.67,"velocity":127},{"end_time":37.0,"pitch":69,"start_time":36.830000000000005,"velocity":127},{"end_time":37.17,"pitch":74,"start_time":37.0,"velocity":127},{"end_time":37.33,"pitch":76,"start_time":37.17,"velocity":127},{"end_time":37.5,"pitch":78,"start_time":37.33,"velocity":127},{"end_time":37.67,"pitch":79,"start_time":37.5,"velocity":127},{"end_time":37.83,"pitch":76,"start_time":37.67,"velocity":127},{"end_time":38.0,"pitch":71,"start_time":37.83,"velocity":127},{"end_time":38.33,"pitch":71,"start_time":38.0,"velocity":127},{"end_time":38.5,"pitch":76,"start_time":38.33,"velocity":127},{"end_time":38.66,"pitch":71,"start_time":38.5,"velocity":127},{"end_time":38.83,"pitch":79,"start_time":38.66,"velocity":127},{"end_time":39.010000000000005,"pitch":71,"start_time":38.83,"velocity":127},{"end_time":39.17,"pitch":76,"start_time":39.010000000000005,"velocity":127},{"end_time":39.34,"pitch":71,"start_time":39.17,"velocity":127},{"end_time":39.67,"pitch":71,"start_time":39.34,"velocity":127},{"end_time":39.84,"pitch":74,"start_time":39.67,"velocity":127},{"end_time":40.00000000000001,"pitch":76,"start_time":39.84,"velocity":127},{"end_time":40.17,"pitch":78,"start_time":40.00000000000001,"velocity":127},{"end_time":40.34,"pitch":79,"start_time":40.17,"velocity":127},{"end_time":40.50000000000001,"pitch":81,"start_time":40.34,"velocity":127},{"end_time":40.67,"pitch":78,"start_time":40.50000000000001,"velocity":127},{"end_time":40.84,"pitch":76,"start_time":40.67,"velocity":127},{"end_time":41.01,"pitch":73,"start_time":40.84,"velocity":127},{"end_time":41.17,"pitch":74,"start_time":41.01,"velocity":127},{"end_time":41.34,"pitch":71,"start_time":41.17,"velocity":127},{"end_time":41.51,"pitch":69,"start_time":41.34,"velocity":127},{"end_time":41.67,"pitch":66,"start_time":41.51,"velocity":127},{"end_time":41.84,"pitch":62,"start_time":41.67,"velocity":127},{"end_time":42.01,"pitch":64,"start_time":41.84,"velocity":127},{"end_time":42.17,"pitch":66,"start_time":42.01,"velocity":127},{"end_time":42.34,"pitch":62,"start_time":42.17,"velocity":127},{"end_time":42.35,"pitch":64,"start_time":42.34,"velocity":127}],"total_time":42.35}}

	
		window.onload = function() {
			var abcString = convertToABC(hardcodedData.transcription);
            ABCJS.renderAbc("music-sheet", abcString);
		    // Only one event listener for the form submit
/*		    document.getElementById('uploadForm').addEventListener('submit', function (e) {
		        e.preventDefault();
		        var fileInput = document.getElementById('audioFile');
		        var formData = new FormData();
		        formData.append('file', fileInput.files[0]);

		        // Show loading spinner
		        document.getElementById('loading').style.display = 'block';
		        document.getElementById('music-sheet').style.display = 'none';

		        fetch(document.getElementById('uploadForm').action, {
		            method: 'POST',
		            body: formData
		        })
		        .then(response => response.json())
		        .then(data => {
		            // Hide loading spinner
		            document.getElementById('loading').style.display = 'none';
		            document.getElementById('music-sheet').style.display = 'block';

		            if (data.transcription) {
		                var abcString = convertToABC(data.transcription);
		                ABCJS.renderAbc("music-sheet", abcString);
		            } else {
		                alert("Transcription failed: " + data.error);
		            }
		        })
		        .catch(error => {
		            console.error('Error:', error);
		            document.getElementById('loading').style.display = 'none';
		        });
		    });*/
		}


		  function convertToABC(transcription) {
		      let abcHeader = "X:1\nT:Transcribed Music\nM:4/4\nL:1/4\nK:C\n";
		      let notes = transcription.notes.map(note => {
		          let pitch = note.pitch % 12;
		          let pitchMap = ['C', '^C', 'D', '^D', 'E', 'F', '^F', 'G', '^G', 'A', '^A', 'B'];
		          let octave = Math.floor(note.pitch / 12) - 4;
		          let abcNote = pitchMap[pitch];

		          if (octave > 0) {
		              abcNote = abcNote.toLowerCase() + "'".repeat(octave - 1);
		          } else if (octave < 0) {
		              abcNote = abcNote.toUpperCase() + ",".repeat(Math.abs(octave) - 1);
		          }

		          let duration = Math.round((note.end_time - note.start_time) * 4) / 4;
		          return duration > 1 ? abcNote + duration : abcNote;
		      });

		      return abcHeader + notes.join(" ");
		  }
      
	  </script>

</body>
</html>