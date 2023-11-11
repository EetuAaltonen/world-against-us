{
  "resourceType": "GMRoom",
  "resourceVersion": "1.0",
  "name": "roomTown",
  "creationCodeFile": "",
  "inheritCode": false,
  "inheritCreationOrder": false,
  "inheritLayers": false,
  "instanceCreationOrder": [
    {"name":"inst_3252815B_1","path":"rooms/roomTown/roomTown.yy",},
    {"name":"inst_2A52911F_1","path":"rooms/roomTown/roomTown.yy",},
    {"name":"inst_AFD5AF0","path":"rooms/roomTown/roomTown.yy",},
    {"name":"inst_26220CA4","path":"rooms/roomTown/roomTown.yy",},
    {"name":"inst_4F5B9360","path":"rooms/roomTown/roomTown.yy",},
    {"name":"inst_5F80EB6B","path":"rooms/roomTown/roomTown.yy",},
    {"name":"inst_6B2595A2","path":"rooms/roomTown/roomTown.yy",},
    {"name":"inst_634BA23A","path":"rooms/roomTown/roomTown.yy",},
    {"name":"inst_21C0046","path":"rooms/roomTown/roomTown.yy",},
    {"name":"inst_6D5E656","path":"rooms/roomTown/roomTown.yy",},
    {"name":"inst_5FC49018","path":"rooms/roomTown/roomTown.yy",},
    {"name":"inst_2A93DCFC","path":"rooms/roomTown/roomTown.yy",},
    {"name":"inst_33AB66E0","path":"rooms/roomTown/roomTown.yy",},
    {"name":"inst_23DCDDF1","path":"rooms/roomTown/roomTown.yy",},
  ],
  "isDnd": false,
  "layers": [
    {"resourceType":"GMREffectLayer","resourceVersion":"1.0","name":"EffectLight","depth":-1100,"effectEnabled":false,"effectType":"_filter_tintfilter","gridX":32,"gridY":32,"hierarchyFrozen":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"inheritSubLayers":true,"inheritVisibility":true,"layers":[],"properties":[
        {"name":"g_TintCol","type":1,"value":"#FFFFFFFF",},
      ],"userdefinedDepth":false,"visible":true,},
    {"resourceType":"GMREffectLayer","resourceVersion":"1.0","name":"EffectFoggy","depth":-1000,"effectEnabled":false,"effectType":"_filter_fractal_noise","gridX":32,"gridY":32,"hierarchyFrozen":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"inheritSubLayers":true,"inheritVisibility":true,"layers":[],"properties":[
        {"name":"g_FractalNoiseScale","type":0,"value":"350",},
        {"name":"g_FractalNoisePersistence","type":0,"value":"0.5",},
        {"name":"g_FractalNoiseOffset","type":0,"value":"0",},
        {"name":"g_FractalNoiseOffset","type":0,"value":"0",},
        {"name":"g_FractalNoiseSpeed","type":0,"value":"0.3",},
        {"name":"g_FractalNoiseTintColour","type":1,"value":"#FFA19999",},
        {"name":"g_FractalNoiseTexture","type":2,"value":"_filter_fractal_noise_texture",},
      ],"userdefinedDepth":true,"visible":true,},
    {"resourceType":"GMREffectLayer","resourceVersion":"1.0","name":"EffectCloudy","depth":-900,"effectEnabled":false,"effectType":"_filter_fractal_noise","gridX":32,"gridY":32,"hierarchyFrozen":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"inheritSubLayers":true,"inheritVisibility":true,"layers":[],"properties":[
        {"name":"g_FractalNoiseScale","type":0,"value":"350",},
        {"name":"g_FractalNoisePersistence","type":0,"value":"0.5",},
        {"name":"g_FractalNoiseOffset","type":0,"value":"0",},
        {"name":"g_FractalNoiseOffset","type":0,"value":"0",},
        {"name":"g_FractalNoiseSpeed","type":0,"value":"0.3",},
        {"name":"g_FractalNoiseTintColour","type":1,"value":"#FF333030",},
        {"name":"g_FractalNoiseTexture","type":2,"value":"_filter_fractal_noise_texture",},
      ],"userdefinedDepth":false,"visible":true,},
    {"resourceType":"GMREffectLayer","resourceVersion":"1.0","name":"EffectWindy","depth":-800,"effectEnabled":false,"effectType":"_effect_windblown_particles","gridX":32,"gridY":32,"hierarchyFrozen":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"inheritSubLayers":true,"inheritVisibility":true,"layers":[],"properties":[
        {"name":"param_sprite","type":2,"value":"sprLeaf",},
        {"name":"param_num_particles","type":0,"value":"60",},
        {"name":"param_particle_spawn_time","type":0,"value":"100",},
        {"name":"param_particle_spawn_all_at_start","type":0,"value":"1",},
        {"name":"param_warmup_frames","type":0,"value":"0",},
        {"name":"param_particle_mass_min","type":0,"value":"0.005",},
        {"name":"param_particle_mass_max","type":0,"value":"0.01",},
        {"name":"param_particle_start_sprite_scale","type":0,"value":"0.3",},
        {"name":"param_particle_end_sprite_scale","type":0,"value":"0.3",},
        {"name":"param_particle_col_1","type":1,"value":"#FFFFFFFF",},
        {"name":"param_particle_col_alt_1","type":1,"value":"#FFFFFFFF",},
        {"name":"param_particle_col_2","type":1,"value":"#FFFFFFFF",},
        {"name":"param_particle_col_alt_2","type":1,"value":"#FFFFFFFF",},
        {"name":"param_particle_col_2_pos","type":0,"value":"0.33",},
        {"name":"param_particle_col_enabled_2","type":0,"value":"0",},
        {"name":"param_particle_col_3","type":1,"value":"#FFFFFFFF",},
        {"name":"param_particle_col_alt_3","type":1,"value":"#FFFFFFFF",},
        {"name":"param_particle_col_3_pos","type":0,"value":"0.66",},
        {"name":"param_particle_col_enabled_3","type":0,"value":"0",},
        {"name":"param_particle_col_4","type":1,"value":"#FFFFFFFF",},
        {"name":"param_particle_col_alt_4","type":1,"value":"#FFFFFFFF",},
        {"name":"param_particle_initial_velocity_range_x_min","type":0,"value":"-100",},
        {"name":"param_particle_initial_velocity_range_x_max","type":0,"value":"100",},
        {"name":"param_particle_initial_velocity_range_y_min","type":0,"value":"-100",},
        {"name":"param_particle_initial_velocity_range_y_max","type":0,"value":"100",},
        {"name":"param_particle_initial_rotation_min","type":0,"value":"0",},
        {"name":"param_particle_initial_rotation_max","type":0,"value":"360",},
        {"name":"param_particle_rot_speed_min","type":0,"value":"-360",},
        {"name":"param_particle_rot_speed_max","type":0,"value":"360",},
        {"name":"param_particle_align_vel","type":0,"value":"1",},
        {"name":"param_particle_lifetime_min","type":0,"value":"100",},
        {"name":"param_particle_lifetime_max","type":0,"value":"100",},
        {"name":"param_particle_update_skip","type":0,"value":"1",},
        {"name":"param_particle_spawn_border_prop","type":0,"value":"0.25",},
        {"name":"param_particle_src_blend","type":0,"value":"5",},
        {"name":"param_particle_dest_blend","type":0,"value":"6",},
        {"name":"param_trails_only","type":0,"value":"0",},
        {"name":"param_trail_chance","type":0,"value":"40",},
        {"name":"param_trail_lifetime_min","type":0,"value":"0.5",},
        {"name":"param_trail_lifetime_max","type":0,"value":"1",},
        {"name":"param_trail_thickness_min","type":0,"value":"0.15",},
        {"name":"param_trail_thickness_max","type":0,"value":"0.15",},
        {"name":"param_trail_col_1","type":1,"value":"#19FFFFFF",},
        {"name":"param_trail_col_alt_1","type":1,"value":"#3FFFFFFF",},
        {"name":"param_trail_col_2","type":1,"value":"#19FFFFFF",},
        {"name":"param_trail_col_alt_2","type":1,"value":"#3FFFFFFF",},
        {"name":"param_trail_col_2_pos","type":0,"value":"0.5",},
        {"name":"param_trail_col_enabled_2","type":0,"value":"1",},
        {"name":"param_trail_col_3","type":1,"value":"#19FFFFFF",},
        {"name":"param_trail_col_alt_3","type":1,"value":"#3FFFFFFF",},
        {"name":"param_trail_col_3_pos","type":0,"value":"0.66",},
        {"name":"param_trail_col_enabled_3","type":0,"value":"0",},
        {"name":"param_trail_col_4","type":1,"value":"#00FFFFFF",},
        {"name":"param_trail_col_alt_4","type":1,"value":"#00FFFFFF",},
        {"name":"param_trail_min_segment_length","type":0,"value":"20",},
        {"name":"param_trail_src_blend","type":0,"value":"5",},
        {"name":"param_trail_dest_blend","type":0,"value":"6",},
        {"name":"param_num_blowers","type":0,"value":"3",},
        {"name":"param_blower_size_min","type":0,"value":"0.2",},
        {"name":"param_blower_size_max","type":0,"value":"0.6",},
        {"name":"param_blower_speed_min","type":0,"value":"0.2",},
        {"name":"param_blower_speed_max","type":0,"value":"0.5",},
        {"name":"param_blower_rot_speed_min","type":0,"value":"-180",},
        {"name":"param_blower_rot_speed_max","type":0,"value":"180",},
        {"name":"param_blower_force_min","type":0,"value":"5",},
        {"name":"param_blower_force_max","type":0,"value":"15",},
        {"name":"param_blower_camvec_scale","type":0,"value":"-1",},
        {"name":"param_force_grid_sizex","type":0,"value":"8",},
        {"name":"param_force_grid_sizey","type":0,"value":"8",},
        {"name":"param_wind_vector_x","type":0,"value":"-4",},
        {"name":"param_wind_vector_y","type":0,"value":"-1",},
        {"name":"param_dragcoeff","type":0,"value":"1",},
        {"name":"param_grav_accel","type":0,"value":"300",},
        {"name":"param_debug_grid","type":0,"value":"0",},
      ],"userdefinedDepth":false,"visible":true,},
    {"resourceType":"GMREffectLayer","resourceVersion":"1.0","name":"EffectRainy","depth":-700,"effectEnabled":false,"effectType":"_filter_fractal_noise","gridX":32,"gridY":32,"hierarchyFrozen":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"inheritSubLayers":true,"inheritVisibility":true,"layers":[],"properties":[
        {"name":"g_FractalNoiseScale","type":0,"value":"350",},
        {"name":"g_FractalNoisePersistence","type":0,"value":"0.5",},
        {"name":"g_FractalNoiseOffset","type":0,"value":"0",},
        {"name":"g_FractalNoiseOffset","type":0,"value":"0",},
        {"name":"g_FractalNoiseSpeed","type":0,"value":"0.3",},
        {"name":"g_FractalNoiseTintColour","type":1,"value":"#FF4C3535",},
        {"name":"g_FractalNoiseTexture","type":2,"value":"_filter_fractal_noise_texture",},
      ],"userdefinedDepth":false,"visible":true,},
    {"resourceType":"GMRInstanceLayer","resourceVersion":"1.0","name":"MapEdge","depth":200,"effectEnabled":true,"effectType":null,"gridX":32,"gridY":32,"hierarchyFrozen":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"inheritSubLayers":true,"inheritVisibility":true,"instances":[
        {"resourceType":"GMRInstance","resourceVersion":"1.0","name":"inst_3252815B_1","colour":4294967295,"frozen":false,"hasCreationCode":false,"ignore":false,"imageIndex":0,"imageSpeed":1.0,"inheritCode":false,"inheritedItemId":null,"inheritItemSettings":false,"isDnd":false,"objectId":{"name":"objMapEdge","path":"objects/objMapEdge/objMapEdge.yy",},"properties":[],"rotation":0.0,"scaleX":0.25,"scaleY":100.0,"x":-16.0,"y":6400.0,},
        {"resourceType":"GMRInstance","resourceVersion":"1.0","name":"inst_2A52911F_1","colour":4294967295,"frozen":false,"hasCreationCode":false,"ignore":false,"imageIndex":0,"imageSpeed":1.0,"inheritCode":false,"inheritedItemId":null,"inheritItemSettings":false,"isDnd":false,"objectId":{"name":"objMapEdge","path":"objects/objMapEdge/objMapEdge.yy",},"properties":[],"rotation":0.0,"scaleX":100.50001,"scaleY":0.25,"x":6400.0005,"y":-16.0,},
        {"resourceType":"GMRInstance","resourceVersion":"1.0","name":"inst_6D5E656","colour":4294967295,"frozen":false,"hasCreationCode":false,"ignore":false,"imageIndex":0,"imageSpeed":1.0,"inheritCode":false,"inheritedItemId":null,"inheritItemSettings":false,"isDnd":false,"objectId":{"name":"objMapEdge","path":"objects/objMapEdge/objMapEdge.yy",},"properties":[],"rotation":0.0,"scaleX":0.25,"scaleY":100.0,"x":12816.0,"y":6400.0,},
        {"resourceType":"GMRInstance","resourceVersion":"1.0","name":"inst_5FC49018","colour":4294967295,"frozen":false,"hasCreationCode":false,"ignore":false,"imageIndex":0,"imageSpeed":1.0,"inheritCode":false,"inheritedItemId":null,"inheritItemSettings":false,"isDnd":false,"objectId":{"name":"objMapEdge","path":"objects/objMapEdge/objMapEdge.yy",},"properties":[],"rotation":0.0,"scaleX":100.50001,"scaleY":0.25,"x":6400.5,"y":12816.0,},
      ],"layers":[],"properties":[],"userdefinedDepth":true,"visible":true,},
    {"resourceType":"GMRInstanceLayer","resourceVersion":"1.0","name":"HighlightedTarget","depth":300,"effectEnabled":true,"effectType":"_filter_outline","gridX":32,"gridY":32,"hierarchyFrozen":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"inheritSubLayers":true,"inheritVisibility":true,"instances":[],"layers":[],"properties":[
        {"name":"g_OutlineColour","type":1,"value":"#FF000EB2",},
        {"name":"g_OutlineRadius","type":0,"value":"1",},
        {"name":"g_OutlinePixelScale","type":0,"value":"3",},
      ],"userdefinedDepth":false,"visible":true,},
    {"resourceType":"GMRInstanceLayer","resourceVersion":"1.0","name":"HighlightedInteractable","depth":400,"effectEnabled":true,"effectType":"_filter_outline","gridX":32,"gridY":32,"hierarchyFrozen":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"inheritSubLayers":true,"inheritVisibility":true,"instances":[],"layers":[],"properties":[
        {"name":"g_OutlineColour","type":1,"value":"#FF00E9FF",},
        {"name":"g_OutlineRadius","type":0,"value":"1",},
        {"name":"g_OutlinePixelScale","type":0,"value":"3",},
      ],"userdefinedDepth":false,"visible":true,},
    {"resourceType":"GMRInstanceLayer","resourceVersion":"1.0","name":"Characters","depth":500,"effectEnabled":true,"effectType":null,"gridX":32,"gridY":32,"hierarchyFrozen":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"inheritSubLayers":true,"inheritVisibility":true,"instances":[
        {"resourceType":"GMRInstance","resourceVersion":"1.0","name":"inst_AFD5AF0","colour":4294967295,"frozen":false,"hasCreationCode":false,"ignore":false,"imageIndex":0,"imageSpeed":1.0,"inheritCode":false,"inheritedItemId":null,"inheritItemSettings":false,"isDnd":false,"objectId":{"name":"objSpawner","path":"objects/objSpawner/objSpawner.yy",},"properties":[],"rotation":0.0,"scaleX":1.0,"scaleY":1.0,"x":6624.0,"y":1472.0,},
        {"resourceType":"GMRInstance","resourceVersion":"1.0","name":"inst_23DCDDF1","colour":4294967295,"frozen":false,"hasCreationCode":false,"ignore":false,"imageIndex":0,"imageSpeed":1.0,"inheritCode":false,"inheritedItemId":null,"inheritItemSettings":false,"isDnd":false,"objectId":{"name":"objBandit","path":"objects/objBandit/objBandit.yy",},"properties":[],"rotation":0.0,"scaleX":1.0,"scaleY":1.0,"x":6144.0,"y":96.0,},
      ],"layers":[],"properties":[],"userdefinedDepth":false,"visible":true,},
    {"resourceType":"GMRInstanceLayer","resourceVersion":"1.0","name":"Facility","depth":600,"effectEnabled":true,"effectType":null,"gridX":32,"gridY":32,"hierarchyFrozen":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"inheritSubLayers":true,"inheritVisibility":true,"instances":[],"layers":[],"properties":[],"userdefinedDepth":false,"visible":true,},
    {"resourceType":"GMRInstanceLayer","resourceVersion":"1.0","name":"Containers","depth":700,"effectEnabled":true,"effectType":null,"gridX":32,"gridY":32,"hierarchyFrozen":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"inheritSubLayers":true,"inheritVisibility":true,"instances":[],"layers":[],"properties":[],"userdefinedDepth":false,"visible":true,},
    {"resourceType":"GMRInstanceLayer","resourceVersion":"1.0","name":"FastTravel","depth":800,"effectEnabled":true,"effectType":null,"gridX":32,"gridY":32,"hierarchyFrozen":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"inheritSubLayers":true,"inheritVisibility":true,"instances":[
        {"resourceType":"GMRInstance","resourceVersion":"1.0","name":"inst_634BA23A","colour":4294967295,"frozen":false,"hasCreationCode":true,"ignore":false,"imageIndex":0,"imageSpeed":1.0,"inheritCode":false,"inheritedItemId":null,"inheritItemSettings":false,"isDnd":false,"objectId":{"name":"objFastTravelSpot","path":"objects/objFastTravelSpot/objFastTravelSpot.yy",},"properties":[],"rotation":0.0,"scaleX":1.2,"scaleY":1.2,"x":6592.0,"y":12768.0,},
        {"resourceType":"GMRInstance","resourceVersion":"1.0","name":"inst_21C0046","colour":4294967295,"frozen":false,"hasCreationCode":true,"ignore":false,"imageIndex":0,"imageSpeed":1.0,"inheritCode":false,"inheritedItemId":null,"inheritItemSettings":false,"isDnd":false,"objectId":{"name":"objModernFrontDoor","path":"objects/objModernFrontDoor/objModernFrontDoor.yy",},"properties":[],"rotation":0.0,"scaleX":1.0,"scaleY":1.0,"x":3258.0,"y":5892.0,},
        {"resourceType":"GMRInstance","resourceVersion":"1.0","name":"inst_33AB66E0","colour":4294967295,"frozen":false,"hasCreationCode":true,"ignore":false,"imageIndex":0,"imageSpeed":1.0,"inheritCode":false,"inheritedItemId":null,"inheritItemSettings":false,"isDnd":false,"objectId":{"name":"objModernFrontDoor","path":"objects/objModernFrontDoor/objModernFrontDoor.yy",},"properties":[],"rotation":0.0,"scaleX":1.0,"scaleY":1.0,"x":9121.0,"y":11140.0,},
      ],"layers":[],"properties":[],"userdefinedDepth":false,"visible":true,},
    {"resourceType":"GMRInstanceLayer","resourceVersion":"1.0","name":"Structures","depth":900,"effectEnabled":true,"effectType":null,"gridX":32,"gridY":32,"hierarchyFrozen":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"inheritSubLayers":true,"inheritVisibility":true,"instances":[
        {"resourceType":"GMRInstance","resourceVersion":"1.0","name":"inst_26220CA4","colour":4294967295,"frozen":false,"hasCreationCode":false,"ignore":false,"imageIndex":0,"imageSpeed":1.0,"inheritCode":false,"inheritedItemId":null,"inheritItemSettings":false,"isDnd":false,"objectId":{"name":"objStreetLight","path":"objects/objStreetLight/objStreetLight.yy",},"properties":[],"rotation":0.0,"scaleX":1.0,"scaleY":1.0,"x":6208.0,"y":12256.0,},
        {"resourceType":"GMRInstance","resourceVersion":"1.0","name":"inst_4F5B9360","colour":4294967295,"frozen":false,"hasCreationCode":false,"ignore":false,"imageIndex":0,"imageSpeed":1.0,"inheritCode":false,"inheritedItemId":null,"inheritItemSettings":false,"isDnd":false,"objectId":{"name":"objStreetLight","path":"objects/objStreetLight/objStreetLight.yy",},"properties":[],"rotation":0.0,"scaleX":1.0,"scaleY":1.0,"x":6208.0,"y":11872.0,},
        {"resourceType":"GMRInstance","resourceVersion":"1.0","name":"inst_5F80EB6B","colour":4294967295,"frozen":false,"hasCreationCode":false,"ignore":false,"imageIndex":0,"imageSpeed":1.0,"inheritCode":false,"inheritedItemId":null,"inheritItemSettings":false,"isDnd":false,"objectId":{"name":"objStreetLight","path":"objects/objStreetLight/objStreetLight.yy",},"properties":[],"rotation":0.0,"scaleX":1.0,"scaleY":1.0,"x":6208.0,"y":11488.0,},
      ],"layers":[],"properties":[],"userdefinedDepth":false,"visible":true,},
    {"resourceType":"GMRInstanceLayer","resourceVersion":"1.0","name":"Building","depth":1000,"effectEnabled":true,"effectType":null,"gridX":32,"gridY":32,"hierarchyFrozen":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"inheritSubLayers":true,"inheritVisibility":true,"instances":[
        {"resourceType":"GMRInstance","resourceVersion":"1.0","name":"inst_6B2595A2","colour":4294967295,"frozen":false,"hasCreationCode":false,"ignore":false,"imageIndex":0,"imageSpeed":1.0,"inheritCode":false,"inheritedItemId":null,"inheritItemSettings":false,"isDnd":false,"objectId":{"name":"objOfficeBuilding","path":"objects/objOfficeBuilding/objOfficeBuilding.yy",},"properties":[],"rotation":0.0,"scaleX":4.2957463,"scaleY":4.2957463,"x":3194.4082,"y":5888.0,},
        {"resourceType":"GMRInstance","resourceVersion":"1.0","name":"inst_2A93DCFC","colour":4294967295,"frozen":false,"hasCreationCode":false,"ignore":false,"imageIndex":0,"imageSpeed":1.0,"inheritCode":false,"inheritedItemId":null,"inheritItemSettings":false,"isDnd":false,"objectId":{"name":"objLibraryBuilding","path":"objects/objLibraryBuilding/objLibraryBuilding.yy",},"properties":[],"rotation":0.0,"scaleX":6.048987,"scaleY":6.048987,"x":9133.2705,"y":11136.0,},
      ],"layers":[],"properties":[],"userdefinedDepth":false,"visible":true,},
    {"resourceType":"GMRPathLayer","resourceVersion":"1.0","name":"PathPatrol","colour":4289900144,"depth":1100,"effectEnabled":true,"effectType":null,"gridX":32,"gridY":32,"hierarchyFrozen":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"inheritSubLayers":true,"inheritVisibility":true,"layers":[],"pathId":{"name":"pthPatrolTown","path":"paths/pthPatrolTown/pthPatrolTown.yy",},"properties":[],"userdefinedDepth":false,"visible":true,},
    {"resourceType":"GMRTileLayer","resourceVersion":"1.1","name":"TilesAsphalt","depth":5000,"effectEnabled":true,"effectType":null,"gridX":32,"gridY":32,"hierarchyFrozen":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"inheritSubLayers":true,"inheritVisibility":true,"layers":[],"properties":[],"tiles":{"SerialiseHeight":100,"SerialiseWidth":100,"TileCompressedData":[
-47,1,-10,2,-90,1,-10,2,-90,1,-10,2,-90,1,-10,2,-90,1,-10,2,-90,1,-10,2,-90,1,-10,2,-90,1,-10,2,-90,1,-10,2,-90,1,-10,2,-90,1,-10,2,-90,1,-10,2,-90,1,-10,2,-90,1,-10,2,-90,1,-10,2,-90,1,-10,2,-90,1,-10,2,-43,1,-1000,2,-47,1,-10,2,-90,1,-10,2,-90,1,-10,2,-90,1,-10,2,-90,1,-10,2,-90,1,-10,2,-90,1,-10,2,
-90,1,-10,2,-90,1,-10,2,-90,1,-10,2,-90,1,-10,2,-90,1,-10,2,-90,1,-10,2,-90,1,-10,2,-90,1,-10,2,-90,1,-10,2,-90,1,-10,2,-90,1,-49,2,-4,3,-47,1,-49,2,-4,3,-20,1,-10,2,-17,1,-49,2,-4,3,-20,1,-10,2,-17,1,-49,2,-4,3,-20,1,-10,2,-17,1,-49,2,-4,3,-20,1,-10,2,-17,1,-49,2,-4,3,-20,1,-10,2,-17,1,-49,2,
-4,3,-20,1,-10,2,-17,1,-49,2,-4,3,-20,1,-10,2,-17,1,-49,2,-4,3,-20,1,-10,2,-17,1,-49,2,-4,3,-20,1,-10,2,-17,1,-10,2,-29,1,-10,2,-4,3,-20,1,-10,2,-17,1,-10,2,-29,1,-10,2,-4,3,-20,1,-10,2,-17,1,-10,2,-29,1,-10,2,-4,3,-20,1,-10,2,-17,1,-10,2,-29,1,-10,2,-4,3,-20,1,-10,2,-17,1,-10,2,-29,1,-10,2,
-4,3,-20,1,-10,2,-17,1,-10,2,-29,1,-10,2,-4,3,-20,1,-10,2,-17,1,-10,2,-29,1,-10,2,-4,3,-20,1,-10,2,-17,1,-10,2,-29,1,-10,2,-4,3,-20,1,-10,2,-17,1,-10,2,-29,1,-10,2,-4,3,-20,1,-10,2,-17,1,-10,2,-29,1,-10,2,-4,3,-20,1,-10,2,-17,1,-10,2,-29,1,-10,2,-4,3,-20,1,-10,2,-17,1,-10,2,-29,1,-10,2,-4,3,
-57,2,-29,1,-10,2,-4,3,-57,2,-29,1,-10,2,-4,3,-57,2,-29,1,-10,2,-4,3,-57,2,-29,1,-10,2,-4,3,-57,2,-29,1,-10,2,-4,3,-57,2,-29,1,-10,2,-4,3,-57,2,-29,1,-10,2,-4,3,-57,2,-29,1,-10,2,-4,3,-57,2,-29,1,-10,2,-4,3,-57,2,-29,1,-10,2,-51,3,-10,2,-29,1,-10,2,-51,3,-10,2,-29,1,-10,2,-51,3,-10,2,-29,1,
-10,2,-51,3,-10,2,-29,1,-10,2,-51,3,-10,2,-29,1,-10,2,-51,3,-10,2,-29,1,-10,2,-51,3,-10,2,-29,1,-10,2,-51,3,-10,2,-29,1,-10,2,-51,3,-10,2,-29,1,-10,2,-51,3,-10,2,-29,1,-10,2,-51,3,-10,2,-29,1,-10,2,-51,3,-49,2,-51,3,-49,2,-51,3,-49,2,-51,3,-49,2,-51,3,-49,2,-51,3,-49,2,-51,3,-49,2,-51,3,-49,2,-51,3,
-49,2,-51,3,-49,2,-51,3,-10,2,-90,3,-10,2,-90,3,-10,2,-43,3,],"TileDataFormat":1,},"tilesetId":{"name":"TileSetAsphalt","path":"tilesets/TileSetAsphalt/TileSetAsphalt.yy",},"userdefinedDepth":true,"visible":true,"x":0,"y":0,},
    {"resourceType":"GMRBackgroundLayer","resourceVersion":"1.0","name":"Background","animationFPS":15.0,"animationSpeedType":0,"colour":4278190080,"depth":5100,"effectEnabled":true,"effectType":null,"gridX":32,"gridY":32,"hierarchyFrozen":false,"hspeed":0.0,"htiled":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"inheritSubLayers":true,"inheritVisibility":true,"layers":[],"properties":[],"spriteId":null,"stretch":false,"userdefinedAnimFPS":false,"userdefinedDepth":false,"visible":true,"vspeed":0.0,"vtiled":false,"x":0,"y":0,},
  ],
  "parent": {
    "name": "Rooms",
    "path": "folders/Rooms.yy",
  },
  "parentRoom": null,
  "physicsSettings": {
    "inheritPhysicsSettings": false,
    "PhysicsWorld": false,
    "PhysicsWorldGravityX": 0.0,
    "PhysicsWorldGravityY": 10.0,
    "PhysicsWorldPixToMetres": 0.1,
  },
  "roomSettings": {
    "Height": 12800,
    "inheritRoomSettings": false,
    "persistent": false,
    "Width": 12800,
  },
  "sequenceId": null,
  "views": [
    {"hborder":32,"hport":768,"hspeed":-1,"hview":768,"inherit":false,"objectId":null,"vborder":32,"visible":false,"vspeed":-1,"wport":1366,"wview":1366,"xport":0,"xview":0,"yport":0,"yview":0,},
    {"hborder":32,"hport":768,"hspeed":-1,"hview":768,"inherit":false,"objectId":null,"vborder":32,"visible":false,"vspeed":-1,"wport":1366,"wview":1366,"xport":0,"xview":0,"yport":0,"yview":0,},
    {"hborder":32,"hport":768,"hspeed":-1,"hview":768,"inherit":false,"objectId":null,"vborder":32,"visible":false,"vspeed":-1,"wport":1366,"wview":1366,"xport":0,"xview":0,"yport":0,"yview":0,},
    {"hborder":32,"hport":768,"hspeed":-1,"hview":768,"inherit":false,"objectId":null,"vborder":32,"visible":false,"vspeed":-1,"wport":1366,"wview":1366,"xport":0,"xview":0,"yport":0,"yview":0,},
    {"hborder":32,"hport":768,"hspeed":-1,"hview":768,"inherit":false,"objectId":null,"vborder":32,"visible":false,"vspeed":-1,"wport":1366,"wview":1366,"xport":0,"xview":0,"yport":0,"yview":0,},
    {"hborder":32,"hport":768,"hspeed":-1,"hview":768,"inherit":false,"objectId":null,"vborder":32,"visible":false,"vspeed":-1,"wport":1366,"wview":1366,"xport":0,"xview":0,"yport":0,"yview":0,},
    {"hborder":32,"hport":768,"hspeed":-1,"hview":768,"inherit":false,"objectId":null,"vborder":32,"visible":false,"vspeed":-1,"wport":1366,"wview":1366,"xport":0,"xview":0,"yport":0,"yview":0,},
    {"hborder":32,"hport":768,"hspeed":-1,"hview":768,"inherit":false,"objectId":null,"vborder":32,"visible":false,"vspeed":-1,"wport":1366,"wview":1366,"xport":0,"xview":0,"yport":0,"yview":0,},
  ],
  "viewSettings": {
    "clearDisplayBuffer": true,
    "clearViewBackground": false,
    "enableViews": false,
    "inheritViewSettings": false,
  },
  "volume": 1.0,
}