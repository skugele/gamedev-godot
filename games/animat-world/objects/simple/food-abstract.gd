extends StaticBody2D

var signature = null

func init_scent_areas(radii):
	for r in radii:
		$Smell.add_scent_area(r, signature)	
