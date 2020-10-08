<?php namespace Config;

// Create a new instance of our RouteCollection class.
$routes = Services::routes();

// Load the system's routing file first, so that the app and ENVIRONMENT
// can override as needed.
if (file_exists(SYSTEMPATH . 'Config/Routes.php'))
{
	require SYSTEMPATH . 'Config/Routes.php';
}

/**
 * --------------------------------------------------------------------
 * Router Setup
 * --------------------------------------------------------------------
 */
$routes->setDefaultNamespace('App\Controllers');
$routes->setDefaultController('Home');
$routes->setDefaultMethod('index');
$routes->setTranslateURIDashes(false);
$routes->set404Override();
$routes->setAutoRoute(true);

/**
 * --------------------------------------------------------------------
 * Route Definitions
 * --------------------------------------------------------------------
 */

// We get a performance increase by specifying the default
// route since we don't have to scan directories.
$routes->get('/', 'Home::index');

$routes->group('/api', function ($routes) {
    $routes->get('login/(:alphanum)/(:alphanum)', 'Rests\Users::login/$1/$2');
	$routes->post('register', 'Rests\Users::register');
	$routes->post('updatetoken', 'Rests\Users::updateToken');
	$routes->get('profile', 'Rests\Users::profile');
	$routes->get('profiles', 'Rests\Users::profiles');
	$routes->post('updateprofile', 'Rests\Users::updateProfile');
	

	$routes->get('projects', 'Rests\Projects::getProjects');
	$routes->post('createproject', 'Rests\Projects::createProject');
	$routes->get('project/(:alphanum)', 'Rests\Projects::getProject/$1');
	$routes->delete('deleteProject/(:alphanum)', 'Rests\Projects::deleteProject/$1');
	$routes->post('projectaddteams/(:alphanum)', 'Rests\Projects::addTeam/$1');


	$routes->post('createbacklog', 'Rests\Tasks::createBacklog');
	$routes->delete('deletebacklog/(:alphanum)', 'Rests\Tasks::deleteBacklog/$1');
	$routes->post('createtask', 'Rests\Tasks::createTask');
	$routes->get('tasks/(:alphanum)', 'Rests\Tasks::getTasks/$1');
	$routes->get('task/(:alphanum)', 'Rests\Tasks::getTask/$1');
	$routes->delete('deletebatchtask', 'Rests\Tasks::deleteBatchTask');
	$routes->get('mytasks/(:alphanum)', 'Rests\Tasks::getMyTasks/$1');
	$routes->post('movetask/(:alphanum)', 'Rests\Tasks::moveToType/$1');
	$routes->get('taskscheck/(:alphanum)', 'Rests\Tasks::getTasksCheck/$1');


	$routes->post('createsprint', 'Rests\Sprints::createSprint');
	$routes->get('sprints/(:alphanum)', 'Rests\Sprints::getSprints/$1');
	$routes->get('test/(:alphanum)', 'Rests\Sprints::test/$1');


	$routes->post('createcomment', 'Rests\Comments::createComment');
});

/**
 * --------------------------------------------------------------------
 * Additional Routing
 * --------------------------------------------------------------------
 *
 * There will often be times that you need additional routing and you
 * need it to be able to override any defaults in this file. Environment
 * based routes is one such time. require() additional route files here
 * to make that happen.
 *
 * You will have access to the $routes object within that file without
 * needing to reload it.
 */
if (file_exists(APPPATH . 'Config/' . ENVIRONMENT . '/Routes.php'))
{
	require APPPATH . 'Config/' . ENVIRONMENT . '/Routes.php';
}
