clc; clear; close all;

in_dir = 'data/netdem/';
file_name = 'contact/contact_000_000000000400000.vtk';
vtk_data = myvtk_read([in_dir,file_name]);