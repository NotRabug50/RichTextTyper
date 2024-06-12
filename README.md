# RichTextTyper

This script adds a typing effect to a RichTextLabel node in Godot Engine. It gradually reveals the text content as if it's being typed out in real-time. The script also supports pausing at specified points and playing audio sounds during typing.

## Properties

### `typing_speed: float`

Controls the speed at which characters are typed out, measured in characters per second.

### `step_size: int`

Defines the number of characters revealed in each typing step.

### `autoplay: bool`

Determines whether the typing effect starts automatically when the scene loads.

### `sounds: Array[AudioStream]`

An array of audio streams that can be played at certain points during typing.

## Methods

### `_ready(): void`

Initializes the script when the node is ready. It strips any BBCode tags from the text content, collects BBCode tags for later use, and sets up pause points if any are specified in the text.

### `_process(delta: float): void`

Updates the typing effect each frame. If the typing is ongoing and not paused, it gradually reveals characters based on the typing speed. It also plays audio sounds if specified and handles pauses at designated points.

### `reset(): void`

Resets the typing effect to its initial state, ready to start again from the beginning.

### `skip(): void`

Skips the typing effect, revealing all text immediately. Useful for skipping long sequences or debugging.

## Internal Functions

### `strip_bbcode(source: String): String`

Removes BBCode tags from the provided text string.

### `collect_bbcode(source: String): String`

Collects all BBCode tags from the provided text string.

### `get_random_sound(): AudioStream`

Returns a random audio stream from the `sounds` array.

## Variables

### `pause_dict: Dictionary`

A dictionary to store pause points in the text and their corresponding durations.

### `playing: bool`

Tracks whether the typing effect is currently active.

### `characters_to_display: float`

Stores the number of characters to be displayed in the current typing step.

### `paused: bool`

Indicates whether the typing effect is currently paused.

### `pause_timer: float`

Tracks the remaining time for the current pause, if any.

### `wait_for_parse: bool`

Flags if the script is currently parsing for wait points in the text.

### `parsed_text: String`

Stores the text content with BBCode tags removed.

### `cparsed_text: String`

Stores the collected BBCode tags from the text.

### `audio: AudioStreamPlayer2D`

Reference to the AudioStreamPlayer2D node for playing sounds during typing.

