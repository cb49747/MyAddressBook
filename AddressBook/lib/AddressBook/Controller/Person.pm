package AddressBook::Controller::Person;

use Moose;
use namespace::autoclean;
BEGIN { extends 'Catalyst::Controller' }
extends 'Catalyst::Controller::FormBuilder';

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
#__PACKAGE__->config(namespace => '');

=encoding utf-8

=head1 NAME

AddressBook::Controller::Root - Root Controller for AddressBook

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 index

The root page (/)

=cut

sub list : Local {
	my ($self, $c) = @_;
	my $people = $c->model('AddressDB::People');
	$c->stash->{people} = $people;
	$c->stash->{template} = 'person/list.tt2';
}

sub delete : Local {
	my ($self, $c, $id) = @_;
	my $person = $c->model('AddressDB::People')->find({id => $id});
	
	## check ACL
	if ($c->user->person) {
		if ($person->id != $c->user->person && !$c->check_any_user_role('editor'))	{
			$c->stash->{error} = 'You are not authorized to delete this person.';
			$c->detach('/auth/access_denied');
		}
	}
	else {
		$c->stash->{error} = 'No Person attached to your login!';
		$c->detach('/person/list');
	}
	
	$c->stash->{person} = $person;
	
	if ($person) {
		$c->flash->{message} = 'Deleted ' . $person->name;
		$person->delete;
	}
	else {
		$c->flash->{error} = "No person $id";
	}
	$c->response->redirect($c->uri_for_action('person/list'));
	$c->detach();
}

sub edit : Local Form{
	my ($self, $c, $id) = @_;
	my $form = $self->formbuilder;
	my $person = $c->model('AddressDB::People')->find_or_new({id => $id});	
	
	## Check ACL
	if ($c->user->person) {
		if ($person->id != $c->user->person && !$c->check_any_user_role('editor'))	{
			$c->stash->{error} = 'You are not authorized to add a new or edit this person.';
			$c->detach('/auth/access_denied');
		}
	}
	else {
		$c->stash->{error} = 'No Person attached to your login!';
		$c->detach('/person/list');
	}
	## End Check ACL
	
	if ($form->submitted && $form->validate) {
		# form was submitted and validated
		$person->firstname($form->field('firstname'));
		$person->lastname($form->field('lastname'));
		$person->update_or_insert;
		$c->flash->{message} = ($id > 0 ? 'Updated ' : 'Added ') . $person->name;
		$c->response->redirect($c->uri_for_action('person/list'));
		$c->detach();
	}
	else {
		# first time thru or invalid form
		if (!$id) { $c->flash->{message} = 'Adding a new person'; }
		$form->field(name => 'firstname', value => $person->firstname, force => 1);
		$form->field(name => 'lastname', value => $person->lastname, force => 1);
	}
}

sub add : Local Form('/person/edit') {
	my ($self, $c) = @_;
	$c->go('edit', []);
}

=head2 end

Attempt to render a view, if needed.

=cut

=head1 AUTHOR

System Administrator

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

## comment out below line when using formbuilder
#__PACKAGE__->meta->make_immutable;

1;