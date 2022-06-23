describe('Home page', function() {
    const BASEX_ROOT = Cypress.env('BASEX_ROOT') || '/app/.heroku/basex'
    const BASEX_PWD = Cypress.env('BASEX_admin_pw') || 'admin'
    it('should show Tunisia with different config', function() {
    	cy.exec(`${BASEX_ROOT}/bin/basexclient -Uadmin -P${BASEX_PWD} -c "OPEN vicav_projects; REPLACE vicav.xml ${Cypress.config()['fileServerFolder']}/fixtures/vicav_projects/map.xml"`)
	    cy.visit('http://localhost:8984/vicav/')
		cy.get('#cookie-overlay').should('be.visible')
		cy.get('.cookie-accept-btn').click()
		cy.get('#cookie-overlay').should('not.be.visible')
	    cy.get('img.leaflet-marker-icon') // Wait until the initial markers appear.
	    cy.get('img[alt^="Khorasan"]').should('not.be.visible');
    })

	it('should show whole Middle-East by deafult', function() {
    	cy.exec(`${BASEX_ROOT}/bin/basexclient -Uadmin -P${BASEX_PWD} -c "OPEN vicav_projects; REPLACE vicav.xml ${Cypress.config()['fileServerFolder']}/fixtures/vicav_projects/vicav.xml"`)
	   	cy.visit('http://localhost:8984/vicav/')
		cy.get('#cookie-overlay').should('be.visible')
		cy.get('.cookie-accept-btn').click()
		cy.get('#cookie-overlay').should('not.be.visible')
    	cy.get('img.leaflet-marker-icon') // Wait until the initial markers appear.
		cy.get('img[alt^="Khorasan"]').should('be.visible');
    })
})