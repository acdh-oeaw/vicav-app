module namespace test = 'http://basex.org/modules/xqunit-tests';
import module namespace vicav = "http://acdh.oeaw.ac.at/vicav" at '../vicav.xqm';

(:~ Initializing function, which is called once before all tests. :)
declare %updating %unit:before-module function test:before-all-tests() {
  db:create('vicav_samples', file:parent(static-base-uri()) || '/../cypress/fixtures/vicav_samples/sampletexts.xml')
};

declare %updating %unit:before-module function test:before-all-test() {
  (:file:write-text(
    file:parent(static-base-uri()) ||'../fixtures/explore-samples-person-only.xml', 
    serialize(vicav:explore-samples-data(
      (), 
      (),
      (), 
      "Test1", 
      "0,100", 
      "m,f", 
      (), 
      "cross_samples_01.xslt"))
  ):)
};
  
(:~ Initializing function, which is called once after all tests. :)
declare %updating %unit:after-module function test:after-all-tests() {
    db:drop('vicav_samples')
};
  
(:~ Initializing function, which is called before each test. :)
declare %unit:before function test:before() {
  ()
};
  
(:~ Initializing function, which is called after each test. :)
declare %unit:after function test:after() {
  ()
};


(:~ Initializing function, which is called after each test. :)
declare %unit:test function test:or_1() {
  unit:assert-equals(vicav:or(("a", ())), "a")
};

(:~ Initializing function, which is called after each test. :)
declare %unit:test function test:or() {
  unit:assert-equals(vicav:or(("a", "b")), "(a or b)")
};

declare %unit:test function test:explore-samples-locations() {
 unit:assert-equals(serialize(vicav:explore-samples-data(
    "Tunis2,Test", 
    "",
    "", 
    "", 
    "0,100", 
    "", 
    "", 
    "cross_samples_01.xslt")), serialize(doc(file:parent(static-base-uri()) || '../fixtures/explore-samples-locations-data.xml'))
  )
};
declare %unit:test function test:explore-samples-word() {
  unit:assert-equals(serialize(vicav:explore-samples-data(
    "", 
    "ṯūm,b*tin*",
    "", 
    "", 
    "", 
    "", 
    "", 
    "cross_samples_01.xslt")), serialize(doc(file:parent(static-base-uri()) || '../fixtures/explore-samples-word-data.xml'))
  )
};

declare %unit:test function test:explore-samples-gender-age-only() {
  unit:assert-equals( serialize(vicav:explore-samples-data(
      (), 
      (),
      (), 
      (), 
      "0,100", 
      "m,f", 
      (), 
      "cross_samples_01.xslt")), serialize(doc(file:parent(static-base-uri()) || '../fixtures/explore-samples-gender-age-only-data.xml'))
  )
};


declare %unit:test function test:explore-samples-locations-persons-data() {
  unit:assert-equals( serialize(vicav:explore-samples-data(
      "Tunis2", 
      (),
      (), 
      "Test1", 
      "0,100", 
      (), 
      (), 
      "cross_samples_01.xslt")), serialize(doc(file:parent(static-base-uri()) || '../fixtures/explore-samples-location-person-data.xml'))
  )
};


declare %unit:test function test:explore-samples-locations-person-only-data() {
  unit:assert-equals( serialize(vicav:explore-samples-data(
      (), 
      (),
      (), 
      "Test1", 
      "0,100", 
      "m,f", 
      (), 
      "cross_samples_01.xslt")), serialize(doc(file:parent(static-base-uri()) || '../fixtures/explore-samples-person-only-data.xml'))
  )
};