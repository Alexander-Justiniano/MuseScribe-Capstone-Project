//--------------------------------------------------------
// Upload Audio
//--------------------------------------------------------
let TRANSCRIPTED_SHEET_MUSIC = null;
let EXTRACTED_NOTES = null;
let CURRENT_NOTEBOOK_ID = null;
let CURRENT_MUSIC_SHEET_ID = null;

let crud = {
	"CREATE":"create",
	"READ":"read",
	"UPDATE":"update",
	"DELETE":"delete",
};

$(document).ready(function () {
  const $musicPanelButtons       = $("#musicsheet-controls-panel > button, #musicsheet-controls-panel button:not(.abcjs-inline-audio *)");
  const $allSettingsPanelInputs  = $("#settings-panel input, #settings-panel select, #settings-panel button");
  const $settingsPanelInputs     = $("#settings-panel input");
  const $settingsPanelDropDowns  = $("#settings-panel select");
  const $settingsPanelButtons    = $("#settings-panel button");
  const $canvasPanelButtons      = $("#uploadShortcutWrapper button");
  const $recordingOptionsButtons = $("#chooseRecordOptionModal button, .upload-button, .chooseRecordOption, #recording-controls button");

  // Combine and disable all controls initially
  const $allControls = $musicPanelButtons
    .add($settingsPanelInputs)
    .add($settingsPanelDropDowns)
    .add($canvasPanelButtons)
    .add($recordingOptionsButtons)
    .add($settingsPanelButtons);

  $allControls.prop('disabled', true);

  //------------------------------------------------------
  // Helper Functions
  //------------------------------------------------------
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
  
  
  function setupAnalyser(source) {
     analyser = audioContext.createAnalyser();
     source.connect(analyser);
     analyser.fftSize = 2048;
     dataArray = new Uint8Array(analyser.fftSize);
   }
   
   async function startRecording() {
		try {
			const devices = await navigator.mediaDevices.enumerateDevices();
			
			const audioInput = devices.some(device => device.kind === 'audioinput');
			
			if (!audioInput) {
				alert("No audio input devices found.");
				console.error("No audio input devices found.");
				return false;
			}
			
			const stream = await navigator.mediaDevices.getUserMedia({ audio: true });
			audioStream = stream;
			audioContext = new (window.AudioContext || window.webkitAudioContext)();
			
			const source = audioContext.createMediaStreamSource(stream);
			setupAnalyser(source);
			recorder = new Recorder(source, { numChannels: 1 });
			recorder.record();
			return true;
		  
		} catch (err) {
		  console.error('Initialization error:', err);
		  return false;
		 }
	 }

	 function stopRecording() {
		isRecording = false;
		if (recorder) {
			if (!isPaused) recorder.stop();
			if (audioStream) audioStream.getTracks().forEach(track => track.stop());
		 }
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

  function updateSheetMusic(abcString) {
    $('#loading').hide();
    $('#music-sheet').show();
    if (abcString) {
      const visualObj = ABCJS.renderAbc('music-sheet', abcString, {
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

  function clearCanvas() {
    const ctx = $waveformCanvas[0].getContext('2d');
    ctx.clearRect(0, 0, $waveformCanvas[0].width, $waveformCanvas[0].height);
  }

  function drawWaveform() {
    const canvas = $waveformCanvas[0],
          ctx    = canvas.getContext('2d'),
          WIDTH  = canvas.width,
          HEIGHT = canvas.height;
    ctx.clearRect(0, 0, WIDTH, HEIGHT);

    if (analyser) {
      analyser.getByteTimeDomainData(dataArray);

      // background
      ctx.fillStyle   = 'rgb(255,240,240)';
      ctx.fillRect(0, 0, WIDTH, HEIGHT);

      // waveform
      ctx.lineWidth   = 2;
      ctx.strokeStyle = 'rgb(224,23,23)';
      ctx.beginPath();
      const sliceWidth = WIDTH / dataArray.length;
      let x = 0;
      for (let i = 0; i < dataArray.length; i++) {
        const v = dataArray[i] / 128.0,
              y = (v * HEIGHT) / 2;
        if (i === 0) ctx.moveTo(x, y);
        else         ctx.lineTo(x, y);
        x += sliceWidth;
      }
      ctx.lineTo(WIDTH, HEIGHT / 2);
      ctx.stroke();

      // only flash when actually recording
      if (isRecording && !isPaused && Math.floor(Date.now() / 500) % 2 === 0) {
        ctx.font         = 'bold 20px sans-serif';
        ctx.fillStyle    = 'red';
        ctx.textAlign    = 'left';
        ctx.textBaseline = 'top';
        ctx.fillText('Recording:', 10, 10);
      }
    }

    animationId = requestAnimationFrame(drawWaveform);
  }


  function drawRecordedWaveform(blob) {
    const reader = new FileReader();
    reader.onload = function () {
      audioContext.decodeAudioData(reader.result, function (buffer) {
        const channelData = buffer.getChannelData(0),
              canvas      = $waveformCanvas[0],
              ctx         = canvas.getContext('2d'),
              WIDTH       = canvas.width,
              HEIGHT      = canvas.height;
        ctx.clearRect(0, 0, WIDTH, HEIGHT);
        const step = Math.ceil(channelData.length / WIDTH);
        ctx.beginPath();
        ctx.moveTo(0, HEIGHT / 2);
        for (let i = 0; i < WIDTH; i++) {
          let sum   = 0,
              count = 0;
          for (let j = 0; j < step; j++) {
            const idx = i * step + j;
            if (idx < channelData.length) {
              sum++;
              count++;
            }
          }
          const avg = sum / count,
                y   = (1 - avg) * (HEIGHT / 2);
          ctx.lineTo(i, y);
        }
        ctx.strokeStyle = 'rgb(0,0,0)';
        ctx.lineWidth   = 2;
        ctx.stroke();
      });
    };
    reader.readAsArrayBuffer(blob);
  }

  function extractNoteSection(abc) {
    const lines     = abc.split('\n');
    const noteLines = [];
    let inNotes     = false;

    for (const line of lines) {
      if (!inNotes && /^[A-Ga-gzZ|:\s]/.test(line)) {
        inNotes = true;
      }
      if (inNotes) noteLines.push(line);
    }

    return noteLines.join('\n');
  }

  function extractHeaderValue(abc, targetKey) {
    let foundValue = null;
    abc.split(/\r?\n/).forEach(line => {
      const match = line.match(/^\s*([A-Za-z][A-Za-z0-9]*)\:(.*?)\s*$/);
      if (match) {
        const [ , key, value ] = match;
        if (key === targetKey) foundValue = value;
      }
    });
    return foundValue;
  }

  function populateInputsFromAbc(abc) {
    $('#abc-title').val(extractHeaderValue(abc, 'T') ? extractHeaderValue(abc, 'T') : "Music Sheet Title");
    $('#abc-composer').val(extractHeaderValue(abc, 'C'));
    $('#abc-transcriber').val(extractHeaderValue(abc, 'Z'));

    const meterVal = extractHeaderValue(abc, 'M');
    if ($("#abc-meter option[value='" + meterVal + "']").length) {
      $('#abc-meter').val(meterVal);
    }
    const lengthVal = extractHeaderValue(abc, 'L');

    if ($("#abc-length option[value='" + lengthVal + "']").length) {
      $('#abc-length').val(lengthVal);
    } else {
      $('#abc-length').val("1/8");
    }

    const tempoVal = extractHeaderValue(abc, 'Q');
    if (tempoVal) {
      $('#abc-tempo').val(tempoVal);
    }

    const keyVal = extractHeaderValue(abc, 'K');
    if ($("#abc-key option[value='" + keyVal + "']").length) {
      $('#abc-key').val(keyVal);
    }
  }

  function buildAbcFromInputs(noteSection) {
    const headers = [
      $("#abc-title").val()        ? "T:" + $("#abc-title").val()        : "T:New Music Sheet",
      $("#abc-composer").val()     ? "C:" + $("#abc-composer").val()     : "",
      $("#abc-transcriber").val()  ? "Z:" + $("#abc-transcriber").val()  : "",
      $("#abc-meter").val()        ? "M:" + $("#abc-meter").val()        : "M:4/4",
      $("#abc-length").val()       ? "L:" + $("#abc-length").val()       : "",
      $("#abc-tempo").val()        ? "Q:" + $("#abc-tempo").val()        : "Q:150",
      $("#abc-key").val()          ? "K:" + $("#abc-key").val()          : ""
    ].filter(Boolean);

    return [...headers, noteSection].join('\n');
  }

  function renderSheetMusicById(element_id, abcString) {
    if (!abcString) {
      alert('Transcription failed.');
      return;
    }

    initSynthControls();
    const visualObj = ABCJS.renderAbc(element_id, abcString, {
      responsive: 'resize',
      dragging: true,
    })[0];

    if (ABCJS.synth.supportsAudio() && window.synthControl) {
      window.synthControl.setTune(visualObj, false);
    }
  }

  //------------------------------------------------------
  // Event Handlers
  //------------------------------------------------------
  // Synth init
  initSynthControls();

  // File upload
  $('#uploadForm').on('submit', function (e) {
    e.preventDefault();
    const file = $('#modal-dropzone-file')[0].files[0];
    if (!file) return;

    const formData = new FormData();
    formData.append('file', file);

    $('#loading').show();
    $("#music-save, #midi-link").prop('disabled', false);
    $('#uploadModal').addClass('hidden');

    fetch('https://secure-darling-minnow.ngrok-free.app/upload', {
      method: 'POST',
      body: formData,
    })
      .then(res => res.json())
      .then(data => {
		const notation = data.transcription?.abc_notation;
        resetModalDropZone();
        if (notation) {
          TRANSCRIPTED_SHEET_MUSIC = notation;
		  EXTRACTED_NOTES = extractNoteSection(notation);
		  $("#music-sheet").removeClass("bg-red-50 border-red-400")
		  $("#music-save").data("save-type",crud.CREATE).attr('data-save-type',crud.CREATE)
          updateSheetMusic(notation);
          populateInputsFromAbc(notation);
		  $allSettingsPanelInputs.prop('disabled', false)
        } else {
          alert('Transcription failed: ' + (data.error || 'unknown error'));
          $('#loading').hide();
          $('#music-sheet').show();
        }
      })
      .catch(err => {
        console.error('Error:', err);
        $('#loading').hide();
      });
  });

  // Fetch test data
  $('#fetchDataBtn').on('click', function (e) {
    e.preventDefault();
    $('#loading').show();
    $('#music-sheet').hide();

    fetch('https://secure-darling-minnow.ngrok-free.app/test-data', {
      method: 'GET',
      headers: { 'ngrok-skip-browser-warning': 'true' },
    })
      .then(res => res.json())
      .then(data => {
        if (data.transcription?.abc_notation) {
          updateSheetMusic(data.transcription.abc_notation);
          TRANSCRIPTED_SHEET_MUSIC = data.transcription.abc_notation;
        } else {
          alert('Failed to fetch test data: ' + (data.error || 'unknown error'));
          $('#loading').hide();
          $('#music-sheet').show();
        }
      })
      .catch(err => {
        console.error('Error:', err);
        $('#loading').hide();
      });
  });

  // Recording controls
  let isRecording = false, isPaused = false, recorder, audioStream, audioContext, recordedBlob, analyser, dataArray, animationId;
  const $recordButton      = $('.recordButton');
  const $stopButton        = $('#stop-recording');
  const $waveformCanvas    = $('#waveform');
  const $recordOptionModal = $('#chooseRecordOptionModal');

  $recordButton.on('click', async function () {
    if (!isRecording || isPaused) {
      const ok = await startRecording();
      if (ok) {
        isRecording = true;
        isPaused = false;
		$waveformCanvas.show()
		$stopButton.prop('disabled', false)
		$recordOptionModal.hide()
		$("#recording-controls").show()
		requestAnimationFrame(drawWaveform);
      } else {
        $("#recording-error").remove();
        $(this).before('<div id="recording-error" class="text-red-500 text-sm mb-2">Error Accessing Recording Device</div>');
      }
    } else {
      if (!isPaused) {
        pauseRecording();
        $recordButton.removeClass('bg-red-100').find('i').attr('data-feather', 'play');
      } else {
        resumeRecording();
        $recordButton.addClass('bg-red-100').find('i').attr('data-feather', 'pause');
      }
      feather.replace();
    }
  });

  $stopButton.on('click', function () {
    if (isRecording) {
      stopRecording();
      $("#recordButton").removeClass('bg-red-100');
	  $(this).prop('disabled', true)
      $(this).removeClass('bg-red-100 animate-pulse text-red-700');
      $('#submit-recording').show();
	  $waveformCanvas.hide()
      $recordButton.find('i').attr('data-feather', 'mic');
      feather.replace();

      recorder.exportWAV(function (blob) {
        recordedBlob = blob;
        drawRecordedWaveform(blob);
      });
    }
  });

  $('#submit-recording').on('click', function () {
    if (!recordedBlob) return;

    const formData = new FormData();
    formData.append('file', recordedBlob, 'recording.wav');
    $('#loading').show();

    fetch('https://secure-darling-minnow.ngrok-free.app/upload', {
      method: 'POST',
      body: formData,
    })
      .then(res => res.json())
      .then(data => {
		const notation = data?.transcription?.abc_notation
        if (notation) {
		  TRANSCRIPTED_SHEET_MUSIC = notation;
	  	  EXTRACTED_NOTES = extractNoteSection(notation);		  	  
          updateSheetMusic(notation);
		  populateInputsFromAbc(notation);
	  	  $allSettingsPanelInputs.prop('disabled', false);
	  	  $("#music-save").data("save-type",crud.CREATE).attr('data-save-type',crud.CREATE);
          $("#music-save, #midi-link").prop('disabled', false);
          $("#submit-recording").prop('disabled', true);
          $("#waveform, #recording-controls").hide();
		  $("#music-sheet").removeClass('bg-red-50 border-red-400');
		  
		  
        } else {
          alert('Transcription failed: ' + (data.error || 'unknown error'));
          $('#loading').hide();
          $('#music-sheet').show();
        }
      })
      .catch(err => {
        console.error('Error:', err);
        $('#loading').hide();
      });
  });

  $('#reset-recording').on('click', function () {
    if (recorder) recorder.clear();
	stopRecording();
    recordedBlob = null;
    isPaused = false;
    $('#recording-controls').hide();
    $waveformCanvas.hide();
    $recordButton.removeClass('bg-red-100').prop('disabled', false).find('i').attr('data-feather', 'mic');
    feather.replace();
    clearCanvas();
  });

  // Notebook & Sheet management
  $('#deleteMusicSheet').on('click', function () {
    const sheetId = $(this).data('musicsheet-id');
    if (!sheetId || !confirm('Are you sure you want to delete this sheet music?')) return;
    $('#loading').show('slow');

    $.ajax({
      url: "/api/music-sheets/"+sheetId,
      method: 'DELETE'
    })
      .done(() => {
        $('#loading').hide('slow');
        $("#music-sheet-carousel ul .sm-sheet-card[data-musicsheet-id='"+sheetId+"']").remove();
        $('#music-sheet').html(`<div id="uploadShortcutWrapper" class="text-xl absolute left-1/2 top-1/2 flex flex-col sm:flex-row gap-5"
		style="transform: translate(-50%, -50%);">
			<div  class="relative">
			  <button class="chooseRecordOption bg-red-500 border-2 border-red-400 rounded p-3 px-4 text-white text-4xl sm:text-xl">
			    Record
			  </button>
			</div>
			<button class="upload-button bg-white rounded p-3 px-4 border-2 border-red-400 text-red-600 text-4xl sm:text-xl">
			    Upload
			</button>
		</div>`).addClass('bg-red-50 border-red-400').css({'padding-bottom':'initial'});
        $(this).removeAttr('data-musicsheet-id').prop('disabled', true);
        alert('Sheet music deleted successfully.');
      })
      .fail(xhr => {
        $('#loading').hide();
        alert('Error deleting sheet music: ' + xhr.responseText);
      });
  });

  $('#deleteNoteBook').on('click', function () {
    const notebookId = $(this).data('notebook-id');
    if (!notebookId || !confirm('Are you sure you want to delete this notebook?')) return;
    $('#loading').show();

    $.ajax({
      url: "/api/notebooks/"+notebookId,
      method: 'DELETE'
    })
      .done(() => window.location.reload())
      .fail(xhr => {
        $('#loading').hide();
        alert('Error deleting notebook: ' + xhr.responseText);
      });
  });

  $('#notebook-carousel').on('click', '#createNewNotebook', function () {
    $('#newNotebookForm').removeClass('hidden');
    $('#newNotebookTitle').val('').focus();
  });

  $('#cancelNewNotebook').on('click', function () {
    $('#newNotebookForm').addClass('hidden');
  });

  $('#submitNewNotebook').on('click', function () {
    const title = $('#newNotebookTitle').val().trim();
    if (!title) return alert("Please enter a title");
    $('#loading').show();

    $.ajax({
      url: "/api/notebooks/"+userId,
      method: 'POST',
      contentType: 'application/json',
      data: JSON.stringify({ title, description: '' })
    })
      .done(notebook => {
        $('#loading').hide();
        $('#newNotebookForm').addClass('hidden');
        const $li = $("<li class='notebook-sheet-card sheet-card p-2 text-center uppercase rounded-lg bg-blue-100 text-blue-900 border-blue-300 font-bold flex-col justify-between border-2 hover:border-blue-800 transition-all duration-1500' data-notebook-id='"+notebook.id+"' data-notebook-title='"+notebook.title+"'>"+notebook.title+"<span class='text-sm text-white font-normal bg-blue-700 rounded-lg px-2 py-1 hover:bg-transparent border-2 border-blue-700 hover:text-blue-800'> Open Book </span> </li>");
        $('#notebook-carousel ul').append($li);
      })
      .fail(xhr => {
        $('#loading').hide();
        alert("Error creating notebook: " + xhr.responseText);
      });
  });

  // SAVE MUSIC SHEET - BUTTON CLICK EVENT LOGIC
  $('#music-save').on('click', function () {
    // grab title & notation
    const title       = $('#abc-title').val().trim() || "Music Sheet Title";
    const abcNotation = TRANSCRIPTED_SHEET_MUSIC || "";
	const requestType = $(this).data('save-type') == crud.UPDATE ? true : false; 

    // see if we're editing an existing sheet:
    const sheetId = CURRENT_MUSIC_SHEET_ID;
    
    // decide URL + method
    const url     = requestType
      ? '/api/music-sheets/' + sheetId      // update endpoint
      : '/api/music-sheets/' + CURRENT_NOTEBOOK_ID;  // creation endpoint
	  
    const method  = requestType ? 'PUT' : 'POST';

    $('#loading').show();
	
    $.ajax({
      url: url,
      method: method,
      contentType: 'application/json',
      data: JSON.stringify({ title: title, abcNotation: abcNotation })
    })
    .done(result => {
      $('#loading').hide();
      if (!sheetId) {
        // on create: store the new ID for future edits
        $('#music-save')
          .data('musicsheet-id', result.id)
          .attr('data-musicsheet-id', result.id);
      }
      alert( sheetId ? "Sheet updated!" : "Sheet created!" );
    })
    .fail(xhr => {
      $('#loading').hide();
      alert("Error saving sheet: " + xhr.responseText);
    });
  });


  $("#notebook-dropdown-btn").on("click", function () {
    $("#notebook-dropdown-btn svg").toggleClass("open");
    $(".notebooks-panel").toggleClass("open");
  });

  $(".chooseRecordOption").off('click').on("click", function () {
    $("#chooseRecordOptionModal").insertBefore(this).show();
  });

  // MOUSE CLICK EVENT LISTER 
  $(document).on('mousedown', function (event) {
    const $modal = $('#chooseRecordOptionModal');
    if ($modal.is(':visible') && !$(event.target).closest('#chooseRecordOptionModal').length) {
      $modal.hide();
    }
  });

  // MIDI RECORD TRIGGER LOGIC
  $("#recordMidiButton").on('click', function () {
    requestMIDIAccess();
    requestMIDIAccess(MIDIOptions);

    navigator.permissions.query({ name: "midi", sysex: true }).then(result => {
      if (result.state === "granted") {
        navigator.requestMIDIAccess().then(onMIDISuccess, onMIDIFailure);
        function onMIDISuccess(midiAccess) {
          console.log("MIDI ready!");
          for (const entry of midiAccess.inputs) entry[1].onmidimessage = onMIDIMessage;
          for (const entry of midiAccess.outputs) { /* ... */ }
        }
        function onMIDIFailure(msg) {
          console.error("Failed to get MIDI access", msg);
        }
        function onMIDIMessage(event) {
          let str = `MIDI message at ${event.timeStamp}: `;
          event.data.forEach(byte => { str += "0x"+byte.toString(16); });
          console.log(str);
        }
      }
    });
  });
  
  // NOTEBOOK CARD CLICK LOGIC

  $('#notebook-carousel').on('click', '.notebook-sheet-card', function () {
    const notebookId    = $(this).data('notebook-id');
    const notebookTitle = $(this).data('notebook-title');
	CURRENT_NOTEBOOK_ID = notebookId;
    $recordingOptionsButtons.prop('disabled', false);
	$('#deleteNoteBook, #music-save').data('notebook-id', notebookId).attr('data-notebook-id', notebookId);

	
    $("#deleteNoteBook").prop('disabled', false)
    $("#music-save").prop('disabled', false)
	
	
    $('#notebook-carousel').hide();
    $('#music-sheet-carousel').show();
    $('#current-notebook-title').text(notebookTitle);
    $('#loading').show();
    $('#music-sheet-carousel ul').empty();

    $.getJSON("/api/notebooks/"+notebookId+"/sheets")
      .done(sheets => {
        $('#loading').hide();
        if (!sheets.length) {
          $('#music-sheet-carousel ul').append('<li>No sheets found.</li>');
          return;
        }
        sheets.forEach((sheet, idx) => {
          const id = idx + 1;
          $('#music-sheet-carousel ul').append(
            "<li id='sheet-music-"+id+"' class='sm-sheet-card rounded-lg relative' data-musicsheet-id='"+sheet.id+"' data-musicsheet-data='"+sheet.abcNotation+"' data-musicsheet-title='"+sheet.title+"'>"+sheet.title+"</li>");
        });

        $('#music-sheet-carousel').find('li').each(function (i) {
			const idx = i+1;
			renderSheetMusicById("sheet-music-"+idx, $(this).data('musicsheet-data'));
        });
      })
      .fail(() => {
        $('#loading').hide();
        alert('Failed to load sheets');
      });
  });
  
  // MUSIC SHEET CARD CLICK LOGIC
  $('#music-sheet-carousel').on('click', '.sm-sheet-card', function () {
    const abc = $(this).data('musicsheet-data') || '';
	CURRENT_MUSIC_SHEET_ID   = $(this).data('musicsheet-id') || null;
	TRANSCRIPTED_SHEET_MUSIC = abc;
    EXTRACTED_NOTES = extractNoteSection(abc);
    populateInputsFromAbc(abc);
    renderSheetMusicById('music-sheet', abc);
	$("#music-save").data("save-type",crud.UPDATE).attr('data-save-type',crud.UPDATE)
    $("#deleteMusicSheet").data("musicsheet-id", $(this).data("musicsheet-id"));
    $('#uploadShortcutWrapper').hide();
    $allControls.prop('disabled', false);
    $("#music-sheet").removeClass("bg-red-50 border-red-400");
  });
	
  // UPDATE SHEEt MUSIC HEADER
  $('#updateAbcHeader').on('click', function () {
    const updatedAbc = buildAbcFromInputs(EXTRACTED_NOTES);	
	TRANSCRIPTED_SHEET_MUSIC = updatedAbc
    renderSheetMusicById('music-sheet', updatedAbc);
  });

  // BACK TO NOTEBOOKS 
  $('#backToNotebooks').on('click', function () {
    $(".chooseRecordOption, .upload-button").prop('disabled', true);
    $('#notebook-carousel').show();
    $('#uploadShortcutWrapper').show();
    $('#music-sheet-carousel').hide();
    $allControls.prop('disabled', true);
  });

  $('.button-wrapper button').hover(function () {
    const tooltipText = $(this).data('tooltip');
    if (!tooltipText) return;
    const $tooltip = $('<div class="custom-tooltip"></div>')
      .text(tooltipText)
      .css({
        position: 'absolute',
        background: 'rgba(0, 0, 0, 0.7)',
        color: '#fff',
        padding: '4px 8px',
        'border-radius': '3px',
        'font-size': '12px',
        'z-index': 1000,
        display: 'none'
      });
    $('body').append($tooltip);
    const offset = $(this).offset();
    $tooltip.css({
      left: offset.left + $(this).outerWidth() / 2 - $tooltip.outerWidth() / 2,
      top:  offset.top - $tooltip.outerHeight() - 5
    }).fadeIn(200);
    $(this).data('tooltipElement', $tooltip);
  }, function () {
    const $tooltip = $(this).data('tooltipElement');
    if ($tooltip) $tooltip.fadeOut(200, () => $tooltip.remove());
  });

});
