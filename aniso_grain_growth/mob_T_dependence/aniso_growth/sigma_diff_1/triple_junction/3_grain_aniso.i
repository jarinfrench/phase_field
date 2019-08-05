[GlobalParams]
  op_num = 3
  var_name_base = gr
  grain_num = 3
[]

[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 10
  ny = 10
  nz = 0
  xmin = 0
  xmax = 250
  ymin = 0
  ymax = 250
  zmin = 0
  zmax = 0
  elem_type = QUAD4
  uniform_refine = 2
  parallel_type = REPLICATED
[]

[Materials]
  [./UO2]
    type = GBAnisotropy
    T = 1000
    Anisotropic_GB_file_name = 3_grains_33%_low_energy_iso_mob.txt
    inclination_anisotropy = true
    delta_sigma = 0.05
    delta_mob = 0.7
    wGB = 20
    molar_volume_value = 24.615e-6 # molar mass of UO2 is 270.03 g/mol, mass density is 10.97 g/cm^3
    time_scale = 1e-06
    # Also uses op_num, var_name_base from GlobalParams
  [../]
[]

[Variables]
  [./gr0]
    order = FIRST
    family = LAGRANGE
    [./InitialCondition]
      type = TricrystalTripleJunctionIC
      theta1 = 120
      theta2 = 120
      op_index = 1
    [../]
  [../]

  [./gr1]
    order = FIRST
    family = LAGRANGE
    [./InitialCondition]
      type = TricrystalTripleJunctionIC
      theta1 = 120
      theta2 = 120
      op_index = 2
    [../]
  [../]

  [./gr2]
    order = FIRST
    family = LAGRANGE
    [./InitialCondition]
      type = TricrystalTripleJunctionIC
      theta1 = 120
      theta2 = 120
      op_index = 3
    [../]
  [../]
[]

[Kernels]
  [./PolycrystalKernel] # Creates the necessary kernels for a polycrystal simulation
    # Uses op_num and var_name_base from GlobalParams
  [../]
[]

[AuxVariables]
  [./bnds]
    order = FIRST
    family = LAGRANGE
  [../]

  [./unique_grains]
    order = CONSTANT
    family = MONOMIAL
  [../]

  [./var_indices]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[AuxKernels]
  [./bnds_calc]
    type = BndsCalcAux
    variable = bnds
    execute_on = 'TIMESTEP_END'
  [../]

  [./unique_grains_calc]
    type = FeatureFloodCountAux
    variable = unique_grains
    execute_on = 'TIMESTEP_END'
    field_display = UNIQUE_REGION
    flood_counter = grain_tracker
  [../]

  [./var_indices_calc]
    type = FeatureFloodCountAux
    variable = var_indices
    execute_on = 'TIMESTEP_END'
    field_display = VARIABLE_COLORING
    flood_counter = grain_tracker
  [../]
[]

[UserObjects]
  [./grain_tracker]
    type = GrainTracker
    execute_on = 'TIMESTEP_END'
    compute_var_to_feature_map = true
  [../]
[]

[Postprocessors]
  [./avg_grain_vol]
    type = AverageGrainVolume
    feature_counter = grain_tracker
    execute_on = 'TIMESTEP_END'
    # Uses op_num and var_name_base from GlobalParams
  [../]

  [./dt]
    type = TimestepSize
  [../]
[]

[VectorPostprocessors]
  [./grain_volume]
    type = FeatureVolumeVectorPostprocessor
    flood_counter = grain_tracker
    execute_on = 'TIMESTEP_END'
    calculate_diameters = true # an additional calculation of the feature 'diameters' - based purely on the volume calculation.
  [../]

  [./histogram]
    type = HistogramVectorPostprocessor
    num_bins = 20
    vpp = grain_volume
  [../]

  [./stats]
    type = StatisticsVectorPostprocessor
    stats = 'average stddev'
    vpp = grain_volume
  [../]
[]

[Executioner]
  type = Transient
  scheme = bdf2
  solve_type = PJFNK
  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart'
  petsc_options_value = 'hypre    boomeramg      101'
  num_steps = 2000

  l_max_its = 30
  nl_max_its = 30

  [./Adaptivity]
    initial_adaptivity = 2
    refine_fraction = 0.7
    coarsen_fraction = 0.1
    max_h_level = 4
  [../]

  [./TimeStepper]
    type = IterationAdaptiveDT
    dt = 1
    optimal_iterations = 8
  [../]
  # maximum total time is 1.0e-6 * num_steps (assuming constant dt = 1)
[]

[Outputs]
  execute_on = 'TIMESTEP_END'
  exodus = true
  csv = true
  file_base = "3_grains_33%_low_energy"
[]
