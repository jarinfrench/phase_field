[GlobalParams]
  op_num = 6
  var_name_base = gr
  grain_num = 6
[]

[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 20
  ny = 20
  nz = 0
  xmin = 0
  xmax = 2500
  ymin = 0
  ymax = 2500
  zmin = 0
  zmax = 0
  elem_type = QUAD4
  uniform_refine = 2
  parallel_type = REPLICATED
[]

[Materials]
  [./CuGrGrAniso]
    type = GBAnisotropy
    T = 600
    Anisotropic_GB_file_name = six_grains_aniso.txt
    inclination_anisotropy = false
    delta_sigma = 0.05
    delta_mob = 0.7

    wGB = 10
    # Also uses op_num, var_name_base, and wGB from GlobalParams
    #molar_volume_value = 7.11e-06 # Default value (for Cu); change if using a different material
  [../]
[]

[Variables]
  [./PolycrystalVariables] # This is an action that creates the necessary variables for a polycrystalline simulation
    # Uses op_num and var_name_base from GlobalParams
  [../]
[]

[Kernels]
  [./PolycrystalKernel] # Sets up ACGrGrPoly, ACInterface, TimeDerivative, and ACGBPoly kernels
    # Uses op_num and var_name_base from GlobalParams
    # Note that the default for variable_mobility is TRUE
  [../]
[]

[AuxVariables]
  [./bnds] # Name of the variable being calculated
    order = FIRST
    family = LAGRANGE
  [../]

  [./unique_grains] # Similarly for these variables
    order = CONSTANT
    family = MONOMIAL
  [../]

  [./var_indices]
    order = CONSTANT
    family = MONOMIAL
  [../]

  [./phi1]
    order = CONSTANT
    family = MONOMIAL
  [../]

  [./Phi]
    order = CONSTANT
    family = MONOMIAL
  [../]

  [./phi2]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[AuxKernels]
  [./BndsCalc]
    # Uses op_num and var_name_base from GlobalParams
    type = BndsCalcAux
    variable = bnds # _Must_ be specified in AuxVariables block
    execute_on = 'TIMESTEP_END'
  [../]

  [./unique_grains]
    type = FeatureFloodCountAux
    variable = unique_grains
    execute_on = 'TIMESTEP_END'
    field_display = UNIQUE_REGION
    flood_counter = grain_tracker
  [../]

  [./var_indices]
    type = FeatureFloodCountAux
    variable = var_indices
    execute_on = 'TIMESTEP_END'
    field_display = VARIABLE_COLORING
    flood_counter = grain_tracker
  [../]

  [./phi1] # first rotation  - about original z axis
    type = OutputEulerAngles
    output_euler_angle = 'phi1'
    grain_tracker = grain_tracker
    variable = phi1
    euler_angle_provider = euler_angles
  [../]

  [./Phi]
    type = OutputEulerAngles # second rotation - about new x axis
    output_euler_angle = 'Phi'
    grain_tracker = grain_tracker
    variable = Phi
    euler_angle_provider = euler_angles
  [../]

  [./phi2]
    type = OutputEulerAngles # third rotation - about the new z axis.
    output_euler_angle = 'phi2'
    grain_tracker = grain_tracker
    variable = phi2
    euler_angle_provider = euler_angles
  [../]
[]

[ICs]
  [./PolycrystalICs]
    [./PolycrystalColoringIC] # Custom action for ICs of a polycrystal
      polycrystal_ic_uo = voronoi
    [../]
  [../]
[]

[BCs]
  [./Periodic]
    [./top_bottom]
      auto_direction = 'x y'
    [../]
  [../]
[]

[UserObjects]
  [./voronoi] # Uses op_num, var_name_base, and grain_num from GlobalParams
    type = PolycrystalVoronoi
    rand_seed = 42
    coloring_algorithm = bt
  [../]

  [./grain_tracker]
    type = GrainTracker
    error_on_grain_creation = true
    execute_on = 'TIMESTEP_END'
    compute_var_to_feature_map = true
    polycrystal_ic_uo = voronoi
    remap_grains = false
    use_single_map = false
  [../]

  [./euler_angles]
    type = RandomEulerAngleProvider
    grain_tracker_object = grain_tracker
    execute_on = 'INITIAL TIMESTEP_END'
    seed = 42
  [../]
[]

[Postprocessors]
  [./avg_grain_vol]
    type = AverageGrainVolume
    feature_counter = grain_tracker
    execute_on = 'TIMESTEP_END'
    # uses op_num and var_name_base from GlobalParams
  [../]

  [./dt]
    type = TimestepSize
  [../]

  [./GrainBoundaryTracking]
  [../]

  [./gb0gb1]
    type = GrainBoundaryArea
    v = 'gr0 gr1'
  [../]

  [./gb0gb2]
    type = GrainBoundaryArea
    v = 'gr0 gr2'
  [../]

  [./gb0gb3]
    type = GrainBoundaryArea
    v = 'gr0 gr3'
  [../]

  [./gb0gb4]
    type = GrainBoundaryArea
    v = 'gr0 gr4'
  [../]

  [./gb0gb5]
    type = GrainBoundaryArea
    v = 'gr0 gr5'
  [../]

  [./gb1gb2]
    type = GrainBoundaryArea
    v = 'gr1 gr2'
  [../]

  [./gb1gb3]
    type = GrainBoundaryArea
    v = 'gr1 gr3'
  [../]

  [./gb1gb4]
    type = GrainBoundaryArea
    v = 'gr1 gr4'
  [../]

  [./gb1gb5]
    type = GrainBoundaryArea
    v = 'gr1 gr5'
  [../]

  [./gb2gb3]
    type = GrainBoundaryArea
    v = 'gr2 gr3'
  [../]

  [./gb2gb4]
    type = GrainBoundaryArea
    v = 'gr2 gr4'
  [../]

  [./gb2gb5]
    type = GrainBoundaryArea
    v = 'gr2 gr5'
  [../]

  [./gb3gb4]
    type = GrainBoundaryArea
    v = 'gr3 gr4'
  [../]

  [./gb3gb5]
    type = GrainBoundaryArea
    v = 'gr3 gr5'
  [../]

  [./gb4gb5]
    type = GrainBoundaryArea
    v = 'gr4 gr5'
  [../]
[]

[VectorPostprocessors]
  [./grain_volume]
    type = FeatureVolumeVectorPostprocessor
    flood_counter = grain_tracker
    execute_on = 'TIMESTEP_END'
  [../]
[]

[Executioner]
  type = Transient
  # Optional parameters
  scheme = bdf2
  solve_type = PJFNK
  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart'
  petsc_options_value = 'hypre    boomeramg      101'
  num_steps = 20

  # Advanced parameters
  #dtmin = 18

  # Solver parameters
  l_max_its = 30
  nl_max_its = 30

  [./Adaptivity] # Mesh adaptivity
    initial_adaptivity = 2
    refine_fraction = 0.7
    coarsen_fraction = 0.1
    max_h_level = 4
  [../]

  [./TimeStepper]
    type = IterationAdaptiveDT
    dt = 15
    optimal_iterations = 8
  [../]
[]

[Outputs]
  execute_on = TIMESTEP_END
  exodus = true
  csv = true
  file_base = "six_grain_polycrystal_iso"
[]
