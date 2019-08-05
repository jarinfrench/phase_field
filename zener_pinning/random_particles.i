[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 10
  ny = 10
  nz = 0
  xmin = 0
  xmax = 2000
  ymin = 0
  ymax = 2000
  zmin = 0
  zmax = 0
  elem_type = QUAD4
  uniform_refine = 2
[]

[GlobalParams]
  op_num = 25
  var_name_base = gr
[]

[Variables]
  [./PolycrystalVariables]
  [../]
[]

[ICs]
  [./PolycrystalICs]
    [./PolycrystalVoronoiVoidIC]
      numbub = 1
      bubspac = 10
      invalue = 1.0
      outvalue = 1.0
      radius = 20
      polycrystal_ic_uo = voronoi
    [../]
  [../]
[]

[AuxVariables]
  [./bnds]
    order = FIRST
    family = LAGRANGE
  [../]
  [./c]
    [./InitialCondition]
      type = MultiSmoothCircleIC
      bubspac = 200
      numbub = 15
      radius = 60
      outvalue = 0.0
      invalue = 1.0
      int_width = 60
      radius_variation_type = uniform
      radius_variation = 0.3
      rand_seed = 42
    [../]
  [../]
[]

[Kernels]
  [./PolycrystalKernel]
    c = c

  [../]
[]

[AuxKernels]
  [./BndsCalc]
    type = BndsCalcAux
    variable = bnds
  [../]
[]

[BCs]
  [./Periodic]
    [./all]
      auto_direction = 'x y'
    [../]
  [../]
[]

[Materials]
  [./Copper]
    type = GBEvolution
    T = 500
    wGB = 60
    GBmob0 = 2.5e-6
    Q = 0.23
    GBenergy = 0.708
  [../]
[]

[UserObjects]
  [./voronoi]
    type = PolycrystalVoronoi
    int_width = 60
    grain_num = 36
    rand_seed = 42
  [../]
[]

[Preconditioning]
  [./SMP]
    type = SMP
    full = true
  [../]
[]

[Executioner]
  type = Transient
  scheme = bdf2
  solve_type = NEWTON

  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart'
  petsc_options_value = 'hypre    boomeramg      31'

  l_tol = 1.0e-4
  l_max_its = 30
  nl_max_its = 20
  nl_rel_tol = 1.0e-9
  start_time = 0.0
  num_steps = 50
  dt = 80.0

  [./Adaptivity]
    initial_adaptivity = 2
    refine_fraction = 0.8
    coarsen_fraction = 0.05
    max_h_level = 2
  [../]
[]

[Outputs]
  execute_on = 'timestep_end'
  csv = true
  exodus = true
[]
