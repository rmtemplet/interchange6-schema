use utf8;
package Interchange6::Schema::Result::Rule;

=head1 NAME

Interchange6::Schema::Result::Rule;

=cut

use strict;
use warnings;

use base qw(DBIx::Class::Core Interchange6::Schema::Base::Attribute);

=head1 TABLE: C<rules>

=cut

__PACKAGE__->table("rules");

=head1 DESCRIPTION

The rules table contains parameters for various rule types. 

Rules are broken into 4 parts.

=over

=item *

B<Object> The rule object defines the data object that the rule will effect.  Objects
require the following attributes (name, field).  A valid name is any result class.
A valid field would be any field which is directly part of that result class.

# Object: Cart object with field shipping
$myrule->add_attribute({ name => 'name'}, 'Cart');
$myrule->add_attribute({ name => 'field'}, 'shipping');

=item *

B<Action> The action of the rule designates what resulting action the rule will perform.
An example of an action is a discount.  The action is dependent on the critera of
the condition (see Condition). 

Actions require the following attributes (operator, function, type, value). 

operator: valid operator values are add, subtract, multiply, divide
function: valid type values are percentage, flat
type: valid types are numeric
value: a valid value is any numeric value

# Action: discount 100 percent
$myrule->add_attribute({ name => 'operator'}, 'subtract');
$myrule->add_attribute({ name => 'function'}, 'percentage');
$myrule->add_attribute({ name => 'type'}, 'numeric');
$myrule->add_attribute({ name => 'value'}, '100');

=item *

B<Condition> The condition which is required gives the action a critera to be met before
the action can be made.

Condition requires the following attributes (operator, type, value or if type = date either a valid_from and or valid_to date .

operator: valid operator values are greater_than_equals_to, less_than_equals_to, greater_than, less_than, equals, between, like
type: valid types are numeric, date, char, 

# Condition greater than or equal numeric value 50.00
$myrule->add_attribute({ name => 'operator'}, 'greater_than_equal_to');
$myrule->add_attribute({ name => 'type'}, 'numeric');
$myrule->add_attribute({ name => 'value'}, 50.00);

=item *

B<Result> Adding a result class to a rule allows the data from that class to be used for
defining the rule.

A result requires the following attributes (name, field, value).

name: Valid name is any result class in the Schema
field: Valid field is any field that is valid in result class
value: Valid value is reference to a record in the 

# Result: Result class ShipmentDestination primary key
$myrule->add_attribute({ name => 'name'}, 'ShipmentDestination');
$myrule->add_attribute({ name => 'field'}, 'id');
$myrule->add_attribute({ name => 'value'}, '1');

=back

=cut

=head1 ACCESSORS

=head2 rules_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 title

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0

=head2 description

  data_type: 'text'
  default_value: (empty string)
  is_nullable: 0

=head2 canonical_rules_id

  This field contains the rules_id of the master rule for which it is 
  dependent. If the field is blank it is assumed to be a master rule.

  data_type: 'integer'
  is_nullable: 1

=head2 strict

  If the master rule is flagged strict no other attributes can be created
  for this rule only attribute_values.

  data_type: 'boolean'
  default_value: true
  is_nullable: 0

=head2 active

  data_type: 'boolean'
  default_value: true
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "rules_id",
 {
    data_type => "integer",
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "name",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "title",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "description",
  { data_type => "text", default_value => "", is_nullable => 0 },
  "canonical_rules_id",
  { data_type => "integer", is_nullable => 1 },
  "strict",
  { data_type => "boolean", default_value => \"true", is_nullable => 0 },
  "active",
  { data_type => "boolean", default_value => \"true", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</rules_id>

=back

=cut

__PACKAGE__->set_primary_key("rules_id");

=head1 METHODS

=head2 test_condition

This method tests the object using the condition and triggers an action
if it is.

=cut

sub validate_condition {
    my ($self, $object, $condition) = @_;
    #the object input is the RuleGroupLine_id defined as the opject

    # search the object for the requires attributes (name, field, value) and make sure they have values.

    # the name attribute must be a result class test that is true

    # we need a method to test that a field exists in the designated class

    # we should get the definition of this field so we can give error if a rule for math is applied to a char etc

    # finally we compare the value of the defined Object field with the condition value using the condition operator

    # if it passes all this then we return ok to apply action if not we do no action.

}

=head2 validate_action

This method validates that the action is properly formated and sane

=cut

sub validate_action {
    my ($self, $object, $condition, $action) = @_;

    # search the action for the requires attributes and make sure they have values.

    # to be continued
}

=head1 RELATIONS

=head2 canonical

Type: belongs_to

Related object: L<Interchange6::Schema::Result::Rule>

=cut

__PACKAGE__->belongs_to(
    "canonical",
    "Interchange6::Schema::Result::Rule",
    {"foreign.rules_id" => "self.canonical_rules_id"},
);

=head2 RuleAttribute

Type: has_many

Related object: L<Interchange6::Schema::Result::RuleAttribute>

=cut

__PACKAGE__->has_many(
  "RuleAttribute",
  "Interchange6::Schema::Result::RuleAttribute",
  { "foreign.rules_id" => "self.rules_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 Variant

Type: has_many

Related object: L<Interchange6::Schema::Result::Rule>

=cut

__PACKAGE__->has_many(
  "Variant",
  "Interchange6::Schema::Result::Rule",
  { "foreign.canonical_rules_id" => "self.rules_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 RuleGroupline

Type: has_many

Related object: L<Interchange6::Schema::Result::RuleGroupline>

=cut

__PACKAGE__->has_many(
  "RuleGroupline",
  "Interchange6::Schema::Result::RuleGroupline",
  { "foreign.rules_id" => "self.rules_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

1;

1;
