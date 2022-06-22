describe('Home page', function() {
    const BASEX_ROOT = Cypress.env('BASEX_ROOT') || '/tmp/build/.heroku/basex'
    const BASEX_PWD = Cypress.env('BASEX_admin_pw') || 'admin'
    it('should show Tunisia with different config', function() {
    	cy.exec(`${BASEX_ROOT}/bin/basexclient -Uadmin -P${BASEX_PWD} -c "OPEN vicav_projects; REPLACE vicav.xml $(pwd)/fixtures/vicav_projects/map.xml"`)
	    cy.visit('http://localhost:8984/vicav/')
	    cy.get('img.leaflet-marker-icon') // Wait until the initial markers appear.
	    cy.get('img[alt^="Khorasan"]').should('not.be.visible');
    })

	it('should show whole Middle-East by deafult', function() {
    	cy.exec(`${BASEX_ROOT}/bin/basexclient -Uadmin -P${BASEX_PWD} -c "OPEN vicav_projects; REPLACE vicav.xml $(pwd)/fixtures/vicav_projects/vicav.xml"`)
	   	cy.visit('http://localhost:8984/vicav/')
    	cy.get('img.leaflet-marker-icon') // Wait until the initial markers appear.
		cy.get('img[alt^="Khorasan"]').should('be.visible');
    })
})