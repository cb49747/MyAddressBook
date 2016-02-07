package AddressBook::Controller::Address;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }
extends 'Catalyst::Controller::FormBuilder';

=head1 NAME

AddressBook::Controller::Address - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 index

=cut

sub add : Local Form('/address/edit') {
	my ($self, $c, $person_id ) = @_;
    $c->go('edit', [undef, $person_id]);
}

sub edit : Local Form {
	my ($self, $c, $address_id, $person_id) = @_;
	my $form = $self->formbuilder;
	my $address;
	
	## Check ACL
	if ($c->user->person) {	
		if (!$address_id) {
			if ($person_id != $c->user->person && !$c->check_any_user_role('editor')) {
				$c->stash->{error} = 'You are not authorized to add an address for this person.';
				$c->detach('/auth/access_denied');	
			}
		}
		else {
			my $address_by_person_id = $c->model('AddressDB::Addresses')->find({person => $c->user->person}, {id => $address_id});
			if (!$address_by_person_id->id && !$c->check_any_user_role('editor'))	{
				$c->stash->{error} = 'You are not authorized to edit the address of this person().';
				$c->detach('/auth/access_denied');
			}
		}
	}
	else {
			$c->stash->{error} = 'No Person attached to your login!';
			$c->detach('/person/list');
	}
	## End Check ACL
	
	if (!$address_id && $person_id) {
		# We are adding a new address to $person
		# Check that the person exists.
		my $person = $c->model('AddressDB::People')->find({id => $person_id});
		if (!$person) { 
			$c->stash->{error} = 'No Such Person';
			$c->detach('/person/list');
		}
		# Create new address
		$address = $c->model('AddressDB::Addresses')->new({person => $person});
	}
	else {
		$address = $c->model('AddressDB::Addresses')->find({id => $address_id});	
		if (!$address) {
			$c->stash->{error} = 'No Such Address!';
			$c->detach('/person/list');
		}
	}
	
	if ($form->submitted && $form->validate) {
		# Transfer data from form to database
		$address->location($form->field('location'));
		$address->postal($form->field('postal'));
		$address->phone($form->field('phone'));
		$address->email($form->field('email'));	
		$address->insert_or_update;
		$c->stash->{message} = ($address_id > 0 ? 'Updated ' : 'Added New ') . 'address for ' . $address->person->name;
		$c->detach('/person/list');	
	}
	else {
		# transfer data from database to form
		$c->stash->{address} = $address;
		if (!$address_id) { $c->stash->{message} = 'Adding a new address '; }
		else { $c->stash->{message} = 'Updating an address '; }
		$c->stash->{message} .= 'for ' . $address->person->name;
		$form->field(name => 'location', value=> $address->location);
		$form->field(name => 'postal', value=> $address->postal);
		$form->field(name => 'phone', value=> $address->phone);
		$form->field(name => 'email', value=> $address->email);
	}
}

sub delete : Local {
	my ($self, $c, $address_id) = @_;
	my $address = $c->model('AddressDB::Addresses')->find({id => $address_id});
	
	## Check ACL
	if ($c->user->person) {	
		if ($address->person->id != $c->user->person && !$c->check_any_user_role('editor'))	{
				$c->stash->{error} = 'You are not authorized to delete the address of this person.';
				$c->detach('/auth/access_denied');
		}
	}
	else {
		$c->stash->{error} = 'No Person attached to your login!';
		$c->detach('/person/list');
	}
	## End Check ACL
	
	if ($address) {
		#Deleted First Last's Home address
		$c->stash->{message} = 'Deleted ' . $address->person->name . q{'s} . $address->location . ' address';
		$address->delete;
	}
	else {
		$c->stash->{error} = 'No Such Address!';
	}
	$c->forward('/person/list');
}

=encoding utf8

=head1 AUTHOR

System Administrator

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

#__PACKAGE__->meta->make_immutable;

1;
