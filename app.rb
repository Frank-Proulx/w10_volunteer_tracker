require('sinatra')
require('sinatra/reloader')
require('./lib/project')
require('./lib/volunteer')
require('pry')
also_reload('lib/**/*.rb')
require 'pg'

DB = PG.connect({:dbname => "volunteer_tracker"})

get('/') do
  @projects = Project.all
  @volunteers = Volunteer.all
  erb(:projects)
end

get('/projects') do
  @projects = Project.all
  @volunteers = Volunteer.all
  erb(:projects)
end

post('/projects') do
  title = params[:title]
  project = Project.new({:title => title, :id => nil})
  project.save
  redirect to('/projects')
end

get('/projects/:id') do
  @project = Project.find(params[:id].to_i)
  @volunteers = Volunteer.all
  @assigned_volunteers = @project.volunteers
  erb(:project)
end

get('/projects/:id/edit') do
  @project = Project.find(params[:id].to_i)
  erb(:edit_project)
end

patch('/projects/:id') do
  @project = Project.find(params[:id].to_i)
  title = params[:title]
  @project.update({:title => title, :id => nil})
  @volunteers = Volunteer.all
  erb(:project)
end

delete('/projects/:id') do
  @project = Project.find(params[:id].to_i)
  @project.delete
  redirect to('/projects')
end

post('/volunteers') do
  name = params[:name]
  volunteer = Volunteer.new({:name => name, :project_id => 0, :id => nil})
  volunteer.save
  redirect to('/projects')
end

get('/volunteer/:id') do
  @projects = Project.all
  @volunteer = Volunteer.find(params[:id].to_i)
  @project = Project.find((@volunteer.project_id).to_i)
  erb(:volunteer)
end

patch('/volunteer/:id') do
  @project = Project.find(params[:title])
  @volunteer = Volunteer.find(params[:id].to_i)
  @volunteer.update(params[:title])
  @volunteer.update_name(params[:name])
  redirect to('/projects')
end