import numpy as np
import plotly
import plotly.graph_objs as go
# import matplotlib.pyplot as plt
# from mpl_toolkits.mplot3d import Axes3D
eta_0 = np.loadtxt('eta_0_step_1000.txt')
eta_1 = np.loadtxt('eta_1_step_1000.txt')
eta_2 = np.loadtxt('eta_2_step_1000.txt')
eta_3 = np.loadtxt('eta_3_step_1000.txt')
# file_data = np.loadtxt('input.txt', dtype = str, usecols = 2)
# grid_size = int(file_data[0])
# dx = float(file_data[2])
# num_grains = int(file_data[4])
# num_steps = int(file_data[5])
# n_step = int(file_data[6])
# dt = float(file_data[7])
# x_max = grid_size * dx
# y_max = grid_size * dx
# y,x = np.mgrid[slice(0,y_max, dx), slice(0,x_max,dx)]

data = [
    go.Surface(z = eta_0),
    go.Surface(z = eta_1),
    go.Surface(z = eta_2),
    go.Surface(z = eta_3)]

plotly.offline.plot(data, filename = 'etas_012_surface_plot.html')
#
# fig = plt.figure()
# ax = fig.add_subplot(111,projection = '3d')
#
# ax.plot_surface(x,y,eta_0)
# ax.plot_surface(x,y,eta_1)
# ax.plot_surface(x,y,eta_2)

# fig2 = plt.figure()
# ax2 = fig2.add_subplot(111, projection = '3d')
# ax2.plot_surface(x,y, np.multiply(np.multiply(eta_0, eta_1), eta_2))
# plt.show()
