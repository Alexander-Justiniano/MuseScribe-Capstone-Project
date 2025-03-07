

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

