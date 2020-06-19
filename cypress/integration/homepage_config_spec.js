describe('Home page', function() {
    it('should show Tunisia with different config', function() {
    	cy.fixture('../../fixtures/vicav_projects/map.xml').then((fixture) => {
    	cy.writeFile('vicav_projects/vicav.xml', fixture);
    	cy.exec(Cypress.env('BASEX_ROOT') + '/bin/basexclient -Uadmin -Padmin -c "OPEN vicav_projects; REPLACE vicav.xml $(pwd)/fixtures/vicav_projects/map.xml"')

	    cy.visit('http://localhost:8984/vicav/')
	    cy.get('img.leaflet-marker-icon') // Wait until the initial markers appear.

	    cy.get('img[alt^="Khorasan"]').should('not.be.visible');
    	});
    })

	it('should show whole Middle-East by deafult', function() {
	    cy.visit('http://localhost:8984/vicav/')
	    cy.get('img.leaflet-marker-icon') // Wait until the initial markers appear.
    	cy.fixture('../../fixtures/vicav_projects/vicav.xml').then((fixture) => {
	    	cy.writeFile('vicav_projects/vicav.xml', fixture);
	    	cy.exec(Cypress.env('BASEX_ROOT') + '/bin/basexclient -Uadmin -Padmin -c "OPEN vicav_projects; REPLACE vicav.xml $(pwd)/fixtures/vicav_projects/vicav.xml"')
		   	cy.visit('http://localhost:8984/vicav/')
	    	cy.get('img.leaflet-marker-icon') // Wait until the initial markers appear.
			cy.get('img[alt^="Khorasan"]').should('be.visible');
	    }
    })
})