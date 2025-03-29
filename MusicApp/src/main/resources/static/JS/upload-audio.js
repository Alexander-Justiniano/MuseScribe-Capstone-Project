
//--------------------------------------------------------Upload Audio--------------------------------------------------------//
$(document).ready(function () {
	let transcribed_sheet_music = null;
	
	function saveMusicSheet(userId, title, abcNotation) {
	    $.ajax({
	        url: "/api/music-sheets/"+userId, // Endpoint
	        method: "POST",
	        contentType: "application/json",
	        data: JSON.stringify({
	            userId: userId,
	            title: title,
	            abcNotation: abcNotation
	        }),
	        success: function(response) {
	            alert("Music sheet saved successfully!");
	            console.log(response);
	        },
	        error: function(xhr, status, error) {
				console.group({userId,title,abcNotation})
	            console.error("Error saving music sheet:", error);
	            alert("Failed to save sheet. Check console for details.");
	        }
	    });
	}
	
  // --- Helper Functions ---
  function defaultModalHTML() {
    return `
      <svg class="w-8 h-8 mb-4 text-gray-500" aria-hidden="true"
           xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 20 16">
        <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
              d="M13 13h3a3 3 0 0 0 0-6h-.025A5.56 5.56 0 0 0 16 6.5 
              5.5 5.5 0 0 0 5.207 5.021C5.137 5.017 5.071 5 5 5a4 4 0 0 0 0 8h2.167M10 15V6m0 0L8 8m2-2 2 2"/>
      </svg>
      <p class="mb-2 text-sm text-gray-500">
         <span class="font-semibold">Click to upload</span> or drag and drop
      </p>
      <p class="text-xs text-gray-500">Only .wav or .mp3 files accepted</p>
    `;
  }
  function resetModalDropZone() {
    $('#modal-dropzone-file').val('');
    $('#modalDropZone').removeClass('dragerror dragover');
    $('#modalDropZoneContent').html(defaultModalHTML());
    $('#modalUploadButtonContainer').hide();
  }
  function initSynthControls() {
    if (ABCJS.synth.supportsAudio() && !window.synthControl) {
      window.synthControl = new ABCJS.synth.SynthController();
      window.synthControl.load('#audio-controls', null, {
        displayLoop: true,
        displayRestart: true,
        displayPlay: true,
        displayProgress: true,
        displayWarp: true,
      });
    }
  }
  
  // render sheet music to main canvas
  function updateSheetMusic(abcString) {
    $('#loading').hide();
    $('#music-sheet').show();
    if (abcString) {
      var visualObj = ABCJS.renderAbc('music-sheet', abcString, {
        responsive: 'resize',
        dragging: true,
      })[0];
      if (ABCJS.synth.supportsAudio()) {
        if (!window.synthControl) initSynthControls();
        window.synthControl.setTune(visualObj, false);
      }
    } else {
      alert('Transcription failed.');
    }
  }
  
  
  initSynthControls();

  // --- File Upload & Test Data (unchanged) ---
  $('#uploadForm').on('submit', function (e) {
    e.preventDefault();
    var file = $('#modal-dropzone-file')[0].files[0];
    if (!file) return;
    var formData = new FormData();
    formData.append('file', file);
    $('#loading').show();
    $('#music-sheet').hide();
    $('#uploadModal').addClass('hidden');
    fetch('https://secure-darling-minnow.ngrok-free.app/upload', {
      method: 'POST',
      body: formData,
    })
      .then((response) => response.json())
      .then((data) => {
		
        resetModalDropZone();
        if (data.transcription && data.transcription.abc_notation) {
          updateSheetMusic(data.transcription.abc_notation);
		  transcribed_sheet_music = data.transcription.abc_notation;
        } else {
          alert('Transcription failed: ' + (data.error || 'unknown error'));
          $('#loading').hide();
          $('#music-sheet').show();
        }
      })
      .catch((error) => {
        console.error('Error:', error);
        $('#loading').hide();
      });
  });
  $('#fetchDataBtn').on('click', function (e) {
    e.preventDefault();
    $('#loading').show();
    $('#music-sheet').hide();
    fetch('https://secure-darling-minnow.ngrok-free.app/test-data', {
      method: 'GET',
      headers: { 'ngrok-skip-browser-warning': 'true' },
    })
      .then((response) => response.json())
      .then((data) => {
        if (data.transcription && data.transcription.abc_notation) {
          updateSheetMusic(data.transcription.abc_notation);
		  transcribed_sheet_music = data.transcription.abc_notation;
        } else {
          alert('Failed to fetch test data: ' + (data.error || 'unknown error'));
          $('#loading').hide();
          $('#music-sheet').show();
        }
      })
      .catch((error) => {
        console.error('Error:', error);
        $('#loading').hide();
      });
  });

  // --- Audio Recording Using Recorder.js ---
  let isRecording = false,
      isPaused = false,
      recorder, audioStream, audioContext, recordedBlob,
      analyser, dataArray, animationId;
  const $recordButton = $('#recordButton');
  const $waveformCanvas = $('#waveform');

  // Helper: Set up a new analyser on the given source.
  function setupAnalyser(source) {
    analyser = audioContext.createAnalyser();
    source.connect(analyser);
    analyser.fftSize = 2048;
    dataArray = new Uint8Array(analyser.fftSize);
  }
  // Helper: Clear canvas.
  function clearCanvas() {
    const ctx = $waveformCanvas[0].getContext('2d');
    ctx.clearRect(0, 0, $waveformCanvas[0].width, $waveformCanvas[0].height);
  }
  // Live waveform drawing.
  function drawWaveform() {
    const canvas = $waveformCanvas[0],
          ctx = canvas.getContext('2d'),
          WIDTH = canvas.width,
          HEIGHT = canvas.height;
    ctx.clearRect(0, 0, WIDTH, HEIGHT);
    if (analyser) {
      analyser.getByteTimeDomainData(dataArray);
      ctx.fillStyle = 'rgb(255,240,240)';
      ctx.fillRect(0, 0, WIDTH, HEIGHT);
      ctx.lineWidth = 2;
      ctx.strokeStyle = 'rgb(224,23,23)';
      ctx.beginPath();
      const sliceWidth = WIDTH / dataArray.length;
      let x = 0;
      for (let i = 0; i < dataArray.length; i++) {
        const v = dataArray[i] / 128.0,
              y = (v * HEIGHT) / 2;
        if (i === 0) ctx.moveTo(x, y);
        else ctx.lineTo(x, y);
        x += sliceWidth;
      }
      ctx.lineTo(WIDTH, HEIGHT / 2);
      ctx.stroke();
    }
    animationId = requestAnimationFrame(drawWaveform);
  }
  // Draw the recorded waveform from the WAV blob.
  function drawRecordedWaveform(blob) {
    const reader = new FileReader();
    reader.onload = function () {
      audioContext.decodeAudioData(reader.result, function (buffer) {
        const channelData = buffer.getChannelData(0),
              canvas = $waveformCanvas[0],
              ctx = canvas.getContext('2d'),
              WIDTH = canvas.width,
              HEIGHT = canvas.height;
        ctx.clearRect(0, 0, WIDTH, HEIGHT);
        const step = Math.ceil(channelData.length / WIDTH);
        ctx.beginPath();
        ctx.moveTo(0, HEIGHT / 2);
        for (let i = 0; i < WIDTH; i++) {
          let sum = 0, count = 0;
          for (let j = 0; j < step; j++) {
            const idx = i * step + j;
            if (idx < channelData.length) {
              sum += channelData[idx];
              count++;
            }
          }
          const avg = sum / count,
                y = (1 - avg) * (HEIGHT / 2);
          ctx.lineTo(i, y);
        }
        ctx.strokeStyle = 'rgb(0,0,0)';
        ctx.lineWidth = 2;
        ctx.stroke();
      });
    };
    reader.readAsArrayBuffer(blob);
  }
  // Start recording: create a new AudioContext, recorder, and analyser.
  async function startRecording() {
    return navigator.mediaDevices.getUserMedia({ audio: true })
      .then(function (stream) {
        audioStream = stream;
        audioContext = new (window.AudioContext || window.webkitAudioContext)();
        const source = audioContext.createMediaStreamSource(stream);
        setupAnalyser(source);
        recorder = new Recorder(source, { numChannels: 1 });
        recorder.record();
      })
      .catch(function (err) {
        console.error('Error accessing audio devices: ' + err);
        $("#recordButton").removeClass('bg-red-100');
        $waveformCanvas.hide();
        $('#recording-controls').hide();
        $('#stop-recording').hide();
        isRecording = false;
        if (err.name === 'NotFoundError') alert('No audio input device found.');
        else if (err.name === 'NotAllowedError') alert('Microphone permission denied.');
        else alert('Error: ' + err.message);
      });
  }
  function pauseRecording() {
    if (recorder && !isPaused) {
      recorder.stop();
      isPaused = true;
    }
  }
  function resumeRecording() {
    if (recorder && isPaused) {
      recorder.record();
      isPaused = false;
    }
  }
  function stopRecording() {
    if (recorder) {
      if (!isPaused) recorder.stop();
      if (audioStream) audioStream.getTracks().forEach(track => track.stop());
    }
  }
  // --- Recording Controls Event Handlers ---
  $recordButton.on('click', function () {
    if (!isRecording || isPaused) {
      isRecording = true;
      isPaused = false;
      startRecording();
      $recordButton.find('i').attr('data-feather', 'pause');
      feather.replace();
      $("#recordButton").addClass('bg-red-100');
      $waveformCanvas.show();
      $('#recording-controls').show();
      $('#stop-recording').show();
      $('#submit-recording').hide();
    } else {
      // Toggle pause/resume.
      if (!isPaused) {
        pauseRecording();
        $("#recordButton").removeClass('bg-red-100');
        $recordButton.find('i').attr('data-feather', 'play');
      } else {
        resumeRecording();
        $("#recordButton").addClass('bg-red-100');
        $recordButton.find('i').attr('data-feather', 'pause');
      }
      feather.replace();
    }
  });
  $('#stop-recording').on('click', function () {
    if (isRecording) {
      stopRecording();
      isRecording = false;
      $("#recordButton").removeClass('bg-red-100');
      $('#stop-recording').hide();
      $('#submit-recording').show();
      $recordButton.find('i').attr('data-feather', 'mic');
      feather.replace();
      recorder.exportWAV(function (blob) {
        recordedBlob = blob;
        drawRecordedWaveform(blob);
      });
    }
  });
  

  const userId = "67da134d5d77463ddecae6af"
  const title = "this is a test"
  
  $('#music-save').on('click', function () {
	if(transcribed_sheet_music){		
		saveMusicSheet(userId, title, transcribed_sheet_music)
	}else{	
		$this.toggleClass("bg-red-100")
	}
  })
  
  $('#submit-recording').on('click', function () {
    if (recordedBlob) {
      let formData = new FormData();
      formData.append('file', recordedBlob, 'recording.wav');
      $('#loading').show();
      $('#music-sheet').hide();
      fetch('https://secure-darling-minnow.ngrok-free.app/upload', {
        method: 'POST',
        body: formData,
      })
        .then(response => response.json())
        .then(data => {
          if (data.transcription && data.transcription.abc_notation) {
            updateSheetMusic(data.transcription.abc_notation);
          } else {
            alert('Transcription failed: ' + (data.error || 'unknown error'));
            $('#loading').hide();
            $('#music-sheet').show();
          }
        })
        .catch(error => {
          console.error('Error:', error);
          $('#loading').hide();
        });
    }
  });
  $('#reset-recording').on('click', function () {
    if (recorder) recorder.clear();
    recordedBlob = null;
    isRecording = false;
    isPaused = false;
    $('#recording-controls').hide();
    $waveformCanvas.hide();
    $("#recordButton").removeClass('bg-red-100');
    $recordButton.prop('disabled', false);
    $recordButton.find('i').attr('data-feather', 'mic');
    feather.replace();
    clearCanvas();
  });
  
  // Start the live waveform loop.
  requestAnimationFrame(drawWaveform);
});

