require 'spec_helper'

describe VersionsController do
  
  it 'should #show successfully' do
    r = Factory.create :rubygem
    v = Factory.create :version, rubygem_id: r.id
    get :show, rubygem_id: r.name, id: v.number
    response.should be_successful
  end

  it 'should redirect to rubygems#index when rubygem not found' do
    get :show, rubygem_id: 'doesntexist', id: 'doesntmatter'
    
    response.should redirect_to rubygems_path
  end
  
  it 'should redirect to all versions if the version doesn\'t exist' do
    r = Factory.create :rubygem
    get :show, rubygem_id: r.name, id: 'doesntexist'
    response.should redirect_to rubygem_path(r.name)
  end

  it 'should redirect when receiving #index' do
    get :index, rubygem_id: 'gem'
    response.should redirect_to rubygem_path('gem')
  end

  it 'should respond to json format' do
    r = Factory.create :rubygem
    v = Factory.create :version, rubygem: r
    10.times { Factory.create :test_result, version: v, rubygem: r }

    get :show, rubygem_id: r.name, id: v.number + '.json'
    response.body.should == v.to_json(include: :test_results)
  end

  it 'should be successful when getting json and version is not found' do
    r = Factory.create :rubygem
    get :show, rubygem_id: r.name, id: '1.0.0.random.json'
    response.should be_successful
    response.body.should == '{}'
  end 
end
