describe('Home page', function() {
    it('should show whole Middle-East by deafult', function() {
		cy.task('deleteFile', 'config.json').then(() => {
	    cy.visit('http://localhost:8984/vicav/')
	    cy.get('img.leaflet-marker-icon') // Wait until the initial markers appear.

	    cy.get('img[alt^="Khorasan"]').should('be.visible');

		});
    })

    it('should show Tunisia with different config', function() {
    	cy.fixture('tunocent.config.json').then((fixture) => {
    	cy.writeFile('config.json', fixture);

	    cy.visit('http://localhost:8984/vicav/')
	    cy.get('img.leaflet-marker-icon') // Wait until the initial markers appear.

	    cy.get('img[alt^="Khorasan"]').should('not.be.visible');
	    cy.task('deleteFile', 'config.json')
    	});
    })
})