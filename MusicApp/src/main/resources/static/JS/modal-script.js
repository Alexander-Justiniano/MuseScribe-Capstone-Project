$(document).ready(function() {
	// Utility: Validate .wav or .mp3
	function isValidAudio(file) {
		return /\.(wav|mp3|mid|midi)$/i.test(file.name);
	}

	// Default drop zone HTML
	const defaultHTML = `
	<i data-feather="upload" class="w-8 h-8mb-4 text-gray-500"></i>
		    <p class="mb-2 text-sm text-gray-500">
		      <span class="font-semibold">Click to upload</span> or drag and drop
		    </p>
		    <p class="text-xs text-gray-500">Only .wav or .mp3 files accepted</p>
		  `;

	// Show the default drop zone content
	function showDefaultContent($zoneContent) {
		$zoneContent.html(defaultHTML);
	}

	// Show an error message and revert after 2 seconds
	function showError($zone, $zoneContent, msg) {
		$zone.addClass('dragerror');
		$zoneContent.html(msg);
		setTimeout(() => {
			$zone.removeClass('dragerror');
			showDefaultContent($zoneContent);
		}, 2000);
	}

	// Show success message and reveal upload button
	function showSuccess($zoneContent, fileName, $buttonContainer) {
		$zoneContent.html(`
		      <i data-feather="check" class="w-8 h-8 mb-4 text-green-500"></i>
		      <p class="mb-2 text-sm text-gray-500">
		        <span class="font-semibold">File ready:</span> ${fileName}
		      </p>
		      <p class="text-xs text-gray-500">File has been selected.</p>
		    `);
		$buttonContainer.css('display', 'flex');
		if (typeof feather !== 'undefined') feather.replace();
	}

	// Handle a dropped/selected file
	function handleFile(file, $zone, $zoneContent, $buttonContainer) {
		if (!isValidAudio(file)) {
			showError(
				$zone,
				$zoneContent,
				`
		          <i data-feather="x" class="w-8 h-8 mb-4 text-red-500"></i>
		          <p class="mb-2 text-sm text-red-500">
		            <span class="font-semibold">Error:</span> Invalid file type.
		          </p>
		          <p class="text-xs text-red-500">Please upload a .wav or .mp3 file.</p>
		        `
			);
			return;
		}
		showSuccess($zoneContent, file.name, $buttonContainer);
	}

	// Common drag handlers
	function handleDragOver(e, $zone) {
		e.preventDefault();
		$zone.addClass('dragover');
	}
	function handleDragLeave(e, $zone) {
		e.preventDefault();
		$zone.removeClass('dragover');
	}
	function handleDrop(e, $zone, $zoneContent, $buttonContainer) {
		e.preventDefault();
		$zone.removeClass('dragover');
		const files = e.originalEvent.dataTransfer?.files;
		if (files?.length) {
			handleFile(files[0], $zone, $zoneContent, $buttonContainer);
		}
	}

	// Initialize a drop zone (modal or main)
	function initDropZone($zone, $zoneContent, $buttonContainer, $fileInput) {
		// Set default content
		showDefaultContent($zoneContent);

		// Drag & drop events
		$zone.on('dragenter dragover', e => handleDragOver(e, $zone));
		$zone.on('dragleave', e => handleDragLeave(e, $zone));
		$zone.on('drop', e => handleDrop(e, $zone, $zoneContent, $buttonContainer));

		// File input change event
		$fileInput.on('change', () => {
			if ($fileInput[0].files?.length) {
				handleFile($fileInput[0].files[0], $zone, $zoneContent, $buttonContainer);
			}
		});
	}

	// Modal open/close
	const $uploadIconButton = $('.upload-button');
	const $uploadModal = $('#uploadModal');
	const $closeModal = $('#closeModal');

	$uploadIconButton.on('click', () => $uploadModal.removeClass('hidden'));
	$closeModal.on('click', () => $uploadModal.addClass('hidden'));
	$uploadModal.on('click', e => {
		if (e.target === $uploadModal[0]) {
			$uploadModal.addClass('hidden');
		}
	});

	// Modal drop zone
	const $modalDropZone = $('#modalDropZone');
	const $modalDropZoneContent = $('#modalDropZoneContent');
	const $modalUploadButtonContainer = $('#modalUploadButtonContainer');
	const $modalFileInput = $('#modal-dropzone-file');
	initDropZone($modalDropZone, $modalDropZoneContent, $modalUploadButtonContainer, $modalFileInput);

	// Main page drop zone
	const $dropZone = $('#dropZone');
	const $dropZoneContent = $('#dropZoneContent');
	const $uploadButtonContainer = $('#uploadButtonContainer');
	const $fileInput = $('#dropzone-file');
	$fileInput.attr('accept', '.wav,.mp3');
	initDropZone($dropZone, $dropZoneContent, $uploadButtonContainer, $fileInput);
});