require('coffee-script');

/**
 * Contructor for objects used to represent enumeration states. Useful
 * when you need to make programmatic updates to an enumerated data type or
 * wish to encapsulate enum states in a handy, re-usable variable.
 * 
 * @param {Array} choices An array of any possible values (choices)
 */
function EnumType(choices) {
	for (var choice in choices) {
		this[choices[choice]] = false;
	}
	this._choices = choices;
}

/**
 * Enable one or more choices (accepts a variable number of arguments)
 * @return {Object} Current instance of EnumType for chaining
 */
EnumType.prototype.enable = function() {
	for (var arg in arguments) {
		this[arguments[arg]] = true;
	}
	return this;
};

/**
 * Disable one or more choices (accepts a variable number of arguments)
 * @return {Object} Current instance of EnumType for chaining
 */
EnumType.prototype.disable = function() {
	for (var arg in arguments) {
		this[arguments[arg]] = false;
	}
	return this;
};

/**
 * Toggles one or more choices (accepts a variable number of arguments)
 * @return {Object} Current instance of EnumType for chaining
 */
EnumType.prototype.toggle = function() {
	for (var arg in arguments) {
		this[arguments[arg]] = ! this[arguments[arg]];
	}
	return this;
};

/**
 * Return all possible values without regard to current state
 * @return {Array} Choices passed to EnumType constructor
 */
EnumType.prototype.all = function() {
	return this._choices;
};

/**
 * Return all enabled choices as an array (used to set list params, usually)
 * @return {Array} Choice values for each choice set to true 
 */
EnumType.prototype.values = function() {
	var value = [];
	for (var choice in this._choices) {
		if (this[this._choices[choice]] === true) {
			value.push(this._choices[choice]);
		}
	}
	return value;
};


// /**
//  * Takes an object and adds an appendTo function that will add
//  * each kvp of object to a query. Used when dealing with complex
//  * parameters that need to be built in an abnormal or unique way.
//  * 
//  * @param {String} name Name of parameter, prefixed to each key
//  * @param {Object} obj  Parameters belonging to the complex type
//  */
// function ComplexType(name) {
// 	this.pre = name;
// 	var _obj = obj;
// 	obj.appendTo = function(query) {
// 		for (var k in _obj) {
// 			query[name + '.' k] = _obj[k];
// 		}
// 		return query;
// 	}
// 	return obj;
// }

// ComplexType.prototype.appendTo = function(query) {
// 	for (var k in value)
// }

/**
 * Complex List helper object. Once initialized, you should set
 * an add(args) method which pushes a new complex object to members.
 * 
 * @param {String} name Name of Complex Type (including .member or subtype)
 */
function ComplexListType(name) {
	this.pre = name;
	this.members = [];
}

/**
 * Appends each member object as a complex list item
 * @param  {Object} query Query object to append to
 * @return {Object}       query
 */
ComplexListType.prototype.appendTo = function(query) {
	var members = this.members;
	for (var i = 0; i < members.length; i++) {
		for (var j in members[i]) {
			query[this.pre + '.' + (i+1) + '.' + j] = members[i][j]
		}
	}
	return query;
};

exports.Client = require('./client').Client;
exports.Request = require('./request').Request;
exports.Enum = EnumType;
exports.ComplexList = ComplexListType;
exports.Products = require('./products.js');
exports.Feeds = require('./feeds.js');
exports.Orders = require('./orders.js');
exports.Reports = require('./reports.js');
