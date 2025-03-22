

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

/*document.getElementById('playButton').addEventListener('click', () => {
	isPlaying = !isPlaying;
	const icon = document.getElementById('playButton').querySelector('i');
	if (isPlaying) {
		icon.setAttribute('data-feather', 'pause');
	} else {
		icon.setAttribute('data-feather', 'play');
	}
	feather.replace();
});*/

// Range input styling
//const range = document.querySelector('input[type="range"]');
//range.style.accentColor = '#4f46e5';

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

$(document).ready(function() {

  // --- Helper HTML Templates ---
  function defaultModalHTML() {
    return `
      <svg class="w-8 h-8 mb-4 text-gray-500" aria-hidden="true"
           xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 20 16">
           <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                 d="M13 13h3a3 3 0 0 0 0-6h-.025A5.56 5.56 0 0 0 16 6.5 5.5 5.5 0 0 0 5.207 5.021C5.137 5.017 5.071 5 5 5a4 4 0 0 0 0 8h2.167M10 15V6m0 0L8 8m2-2 2 2"/>
      </svg>
      <p class="mb-2 text-sm text-gray-500">
         <span class="font-semibold">Click to upload</span> or drag and drop
      </p>
      <p class="text-xs text-gray-500">Only .wav or .mp3 files accepted</p>
    `;
  }

  function getErrorHTML() {
    return `
      <i data-feather="x" class="w-8 h-8 mb-4 text-red-500"></i>
      <p class="mb-2 text-sm text-red-500">
         <span class="font-semibold">Error:</span> Invalid file type.
      </p>
      <p class="text-xs text-red-500">Please upload a .wav or .mp3 file.</p>
    `;
  }

  function getSuccessHTML(fileName, actionMsg) {
    return `
      <i data-feather="check" class="w-8 h-8 mb-4 text-green-500"></i>
      <p class="mb-2 text-sm text-gray-500">
         <span class="font-semibold">File ready:</span> ${fileName}
      </p>
      <p class="text-xs text-gray-500">${actionMsg}</p>
    `;
  }

  // --- Modal Drop Zone Reset ---
  function resetModalDropZone() {
    $('#modal-dropzone-file').val('');
    $('#modalDropZone').removeClass('dragerror dragover');
    $('#modalDropZoneContent').html(defaultModalHTML());
    $('#modalUploadButtonContainer').hide();
  }

  // --- Initialize ABC.js Audio Controls ---
  function initSynthControls() {
    if (ABCJS.synth.supportsAudio() && !window.synthControl) {
      window.synthControl = new ABCJS.synth.SynthController();
      window.synthControl.load("#audio-controls", null, {
        displayLoop: true,
        displayRestart: true,
        displayPlay: true,
        displayProgress: true,
        displayWarp: true
      });
    }
  }

  // --- Update Music Sheet and Audio Controls ---
  function updateSheetMusic(abcString) {
    $('#loading').hide();
    $('#music-sheet').show();
    if (abcString) {
      var visualObj = ABCJS.renderAbc("music-sheet", abcString, {
        responsive: "resize",
        dragging: true
      })[0];
      if (ABCJS.synth.supportsAudio()) {
        if (!window.synthControl) { initSynthControls(); }
        window.synthControl.setTune(visualObj, false);
      }
    } else {
      alert("Transcription failed.");
    }
  }

  // --- Initialize controls on page load ---
  initSynthControls();

  // --- Upload Form Submission ---
  $('#uploadForm').on('submit', function(e) {
    e.preventDefault();
    var file = $('#modal-dropzone-file')[0].files[0];
    if (!file) { return; }
    var formData = new FormData();
    formData.append('file', file);

    // Show spinner, hide music sheet, and close the modal
    $('#loading').show();
    $('#music-sheet').hide();
    $('#uploadModal').addClass('hidden');

    // POST file to the upload endpoint
    fetch('https://secure-darling-minnow.ngrok-free.app/upload', {
      method: 'POST',
      body: formData
    })
    .then(response => response.json())
    .then(data => {
      resetModalDropZone();
      if (data.transcription && data.transcription.abc_notation) {
        updateSheetMusic(data.transcription.abc_notation);
      } else {
        alert("Transcription failed: " + (data.error || "unknown error"));
        $('#loading').hide();
        $('#music-sheet').show();
      }
    })
    .catch(error => {
      console.error('Error:', error);
      $('#loading').hide();
    });
  });

  // --- Fetch Test Data Button ---
  $('#fetchDataBtn').on('click', function(e) {
    e.preventDefault();
    $('#loading').show();
    $('#music-sheet').hide();
    fetch("https://secure-darling-minnow.ngrok-free.app/test-data", {
      method: "GET",
      headers: { "ngrok-skip-browser-warning": "true" }
    })
    .then(response => response.json())
    .then(data => {
      if (data.transcription && data.transcription.abc_notation) {
        updateSheetMusic(data.transcription.abc_notation);
      } else {
        alert("Failed to fetch test data: " + (data.error || "unknown error"));
        $('#loading').hide();
        $('#music-sheet').show();
      }
    })
    .catch(error => {
      console.error('Error:', error);
      $('#loading').hide();
    });
  });

});



