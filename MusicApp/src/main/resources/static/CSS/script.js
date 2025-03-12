

// Initialize Feather Icons
feather.replace();

// Recording state
let isRecording = false;
let isPlaying = false;

// Button handlers
document.getElementById('recordButton').addEventListener('click', () => {
	isRecording = !isRecording;
	document.getElementById('recordButton').classList.toggle('bg-red-100');
});

document.getElementById('playButton').addEventListener('click', () => {
	isPlaying = !isPlaying;
	const icon = document.getElementById('playButton').querySelector('i');
	if (isPlaying) {
		icon.setAttribute('data-feather', 'pause');
	} else {
		icon.setAttribute('data-feather', 'play');
	}
	feather.replace();
});

// Range input styling
const range = document.querySelector('input[type="range"]');
range.style.accentColor = '#4f46e5';

//Dropdown Menu
document.addEventListener("DOMContentLoaded", function () {
    const dropdownBtn = document.querySelector(".dropdown-btn");
    const dropdownContent = document.querySelector(".dropdown-content");

    dropdownBtn.addEventListener("click", function (event) {
// Prevents immediate closing when clicking the button
        event.stopPropagation(); 	
        dropdownContent.style.display = dropdownContent.style.display === "block" ? "none" : "block";
    });

    // Close dropdown if user clicks outside
    document.addEventListener("click", function (event) {
        if (!dropdownBtn.contains(event.target) && !dropdownContent.contains(event.target)) {
            dropdownContent.style.display = "none";
        }
    });
});



//--------------------------------------------------------Experimental Tooltip Feature--------------------------------------------------------//





// Get the button and tooltip elements
const tooltipBtn = document.getElementById('recordButton');  // Change this to select by ID
const tooltip = document.querySelector('.tooltip');

// Add a hover event listener to the button
tooltipBtn.addEventListener('mouseover', () => {
    // Show the tooltip after a delay of 2 seconds
    setTimeout(() => {
        tooltip.classList.remove('hidden');
        tooltip.classList.add('block'); // Make the tooltip visible
        tooltip.classList.add('opacity-0');  // Start from invisible
        tooltip.classList.add('transition-opacity');
        tooltip.classList.add('duration-300');
        tooltip.classList.add('opacity-100'); // Fade in the tooltip
    }, 2000); // 2 seconds delay
});

// Hide the tooltip when the mouse leaves the button
tooltipBtn.addEventListener('mouseleave', () => {
    tooltip.classList.add('hidden');
    tooltip.classList.remove('block');
});

//--------------------------------------------------------Upload Audio--------------------------------------------------------//



window.onload = function() {
		// Event listener for form submission (upload audio file)
	document.getElementById('uploadForm').addEventListener('submit', function(e) {
	  e.preventDefault(); // Prevent the default form submission (page reload)
	
	  var fileInput = document.getElementById('modal-dropzone-file');// file input field
	  console.log(fileInput.files[0])
	  var formData = new FormData();
	  formData.append('file', fileInput.files[0]);
	
	  // Show loading spinner and hide the music sheet area during processing
	  document.getElementById('loading').style.display = 'block';
	  //document.getElementById('music-sheet').style.display = 'none';
	
	  // close modal on upload
	  const uploadModal = document.getElementById('uploadModal');
      uploadModal.classList.add('hidden');

	  
      // Make POST request to the upload endpoint
      fetch(`https://secure-darling-minnow.ngrok-free.app/upload`, {
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
              ABCJS.renderAbc("music-sheet", abcString,{ responsive: "resize" });
          } else {
              alert("Transcription failed: " + data.error);
          }
      })
      .catch(error => {
          console.error('Error:', error);
          document.getElementById('loading').style.display = 'none';
      });
  	});

	const requestOptions = {
	  method: "GET",
	  
	  headers: {
	       "ngrok-skip-browser-warning": "true"
	  }
	};

      // Event listener for the "Fetch Data" button
      document.getElementById('fetchDataBtn').addEventListener('click', function(e) {
          e.preventDefault(); // Prevent any default action

          // Show loading spinner and hide music sheet area during processing
          document.getElementById('loading').style.display = 'block';
          document.getElementById('music-sheet').style.display = 'none';

          // Make a GET request to the /test-data endpoint
		fetch("https://secure-darling-minnow.ngrok-free.app/test-data", requestOptions)
          .then(response => response.json()) // Parse JSON response
          .then(data => {
			
              // Hide loading spinner and show music sheet area
              document.getElementById('loading').style.display = 'none';
              document.getElementById('music-sheet').style.display = 'block';

              // Check if the returned JSON contains ABC notation
              if (data.transcription && data.transcription.abc_notation) {
                  var abcString = data.transcription.abc_notation;
                  // Render the ABC notation using ABC.js
                  var visualObj = ABCJS.renderAbc("music-sheet", abcString,{ responsive: "resize",dragging: true })[0];
				  var midi = ABCJS.synth.getMidiFile(abcString, { chordsOff: true, midiOutputType: "encoded" });
				  
				  document.getElementById("midi-link").setAttribute("html", midi);
	
				    if (ABCJS.synth.supportsAudio()) {
				      // Create a synth controller instance and store it globally.
				      synthControl = new ABCJS.synth.SynthController();
				      // We don't call synthControl.load() so that we can use our custom controls.
				      // Instead, we simply set the tune.
				      synthControl.setTune(visualObj, false).then(function () {
				        console.log("Tune is ready for playback");
				      }).catch(function (error) {
				        console.error("Error setting tune:", error);
				      });
				    } else {
				      document.querySelector("#audio").innerHTML = "<div class='audio-error'>Audio is not supported in this browser.</div>";
				    }
				


				  // Play button (with id "playButton" and classes "abcjs-midi-start abcjs-btn")
				  document.getElementById("playButton").addEventListener("click", function () {
				    if (synthControl) {
				      synthControl.play();
				    }
				  });

				  // Stop button – make sure your HTML stop button has an id "stopButton"
				  document.getElementById("stopButton").addEventListener("click", function () {
				    if (synthControl) {
				      synthControl.stop();
				    }
				  });

	
				  
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


