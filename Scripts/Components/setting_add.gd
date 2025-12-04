# setup_project_settings.gd
extends Node

func _ready():
	# Check and add WindDirection
	if not ProjectSettings.has_setting("WindDirection"):
		ProjectSettings.set_setting("WindDirection", Vector3(1, 0, 0))
		
	# Example: add two more water shader settings
	if not ProjectSettings.has_setting("GaleStrength"):
		ProjectSettings.set_setting("GaleStrength", float(1.0))
	if not ProjectSettings.has_setting("OceanWavesGradient"):
		ProjectSettings.set_setting("OceanWavesGradient", (1.0))
		
	# Save changes to project.godot
	ProjectSettings.save()
	
	print("Water shader project settings added!")
