class Nave {
	var property velocidad
	var property direccionAlSol
	var property combustible
	
	method acelerar(cuanto) { velocidad = (velocidad + cuanto).min(100000) }
	
	method desAcelerar(cuanto) { velocidad = (velocidad - cuanto).max(0) }
	
	method irHaciaElSol() { direccionAlSol = 10 }
	
	method escaparDelSol() { direccionAlSol = -10 }
	
	method ponerseParaleloAlSol() { direccionAlSol = 0 }
	
	method acercarseUnPocoAlSol() { direccionAlSol = (direccionAlSol + 1).min(10) }
	
	method alejarseUnPocoDelSol() { direccionAlSol = (direccionAlSol - 1).max(0) }
	
	method cargarCombustible(cantidad) { combustible += cantidad }
	
	method descargarCombustible(cantidad) { combustible = (combustible - cantidad).max(0) }
	
	method prepararCombustibleParaViaje() {
		self.cargarCombustible(30000)
		self.acelerar(5000)
	}
	
	method estaTranquila() = self.condicionComun() and self.condicionAdicional()
	
	method condicionComun() = combustible >= 4000 and velocidad <= 12000
	
	method condicionAdicional()
	
	method estaDeRelajo() = self.estaTranquila() and self.tienePocaActividad()
	
	method tienePocaActividad()
}

class NaveDeCombate inherits Nave {
	const property mensajesEmitidos = []
	var invisible
	var misilesDesplegados
	
	method ponerseInvisible() { invisible = true }
	method ponerseVisible() { invisible = false }
	method estaInvisible() = invisible
	
	method desplegarMisiles() { misilesDesplegados = true }
	method replegarMisiles() { misilesDesplegados = false }
	method misilesDesplegados() = misilesDesplegados
	
	method emitirMensaje(mensaje) { mensajesEmitidos.add(mensaje) }
	
	method primerMensajeEmitido() = mensajesEmitidos.first()
	
	method ultimoMensajeEmitido() = mensajesEmitidos.last()
	
	method emitioMensaje(mensaje) = mensajesEmitidos.contains(mensaje)
	
	method esEscueta() = !mensajesEmitidos.any({m => m.size() > 30})
	
	method prepararViaje() {
		self.prepararCombustibleParaViaje()
		self.ponerseVisible()
		self.replegarMisiles()
		self.acelerar(15000)
		self.emitirMensaje("Saliendo en misión")
	}
	
	override method condicionAdicional() = !misilesDesplegados
	
	method recibirAmenaza() {
		self.escapar()
		self.avisar()
	}
	
	method escapar() {
		self.acercarseUnPocoAlSol()
		self.acercarseUnPocoAlSol()
	}
	
	method avisar() {
		self.emitirMensaje("Amenaza recibida")
	}
	
	override method tienePocaActividad() = self.esEscueta()
}

class NaveDeCombateSigilosa inherits NaveDeCombate {
	
	override method condicionAdicional() = !misilesDesplegados and !invisible
	override method escapar() {
		self.acercarseUnPocoAlSol()
		self.acercarseUnPocoAlSol()
		self.desplegarMisiles()
		self.ponerseInvisible()
	}
}

class NaveBaliza inherits Nave {
	var colorDeBaliza = ""
	var cambioSuColor = true
	
	method cambiarColorDeBaliza(nuevoColor) { 
		colorDeBaliza = nuevoColor
		cambioSuColor = false
	}
	
	method prepararViaje() {
		self.prepararCombustibleParaViaje()
		self.cambiarColorDeBaliza("verde")
		self.ponerseParaleloAlSol()
	}
	
	override method condicionAdicional() = colorDeBaliza != "rojo"
	
	method recibirAmenaza() {
		self.escapar()
		self.avisar()
	}
	
	method escapar() {
		self.irHaciaElSol()
	}
	
	method avisar() {
		self.cambiarColorDeBaliza("rojo")
	}
	
	override method tienePocaActividad() = !cambioSuColor
}

class NaveDePasajeros inherits Nave {
	var property pasajeros
	var property racionesComida
	var property racionesBebida
	var property comidaConsumida
	var property bebidaConsumida
	
	
	method cargarComida(cantidad) { racionesComida += cantidad }
	
	method descargarOConsumirComida(cantidad) { 
		racionesComida = (racionesComida - cantidad).max(0)
		comidaConsumida += cantidad
	}
	
	method cargarBebida(cantidad) { racionesBebida += cantidad }
	
	method descargarOConsumirBebida(cantidad) { 
		racionesBebida = (racionesBebida - cantidad).max(0)
		bebidaConsumida += cantidad
	}
	
	method prepararViaje() {
		self.prepararCombustibleParaViaje()
		self.cargarComida(4 * pasajeros)
		self.cargarBebida(6 * pasajeros)
		self.acercarseUnPocoAlSol()
	}
	
	method recibirAmenaza() {
		self.escapar()
		self.avisar()
	}
	
	method escapar() {
		velocidad = velocidad * 2
	}
	
	method avisar() {
		self.descargarOConsumirComida(pasajeros)
		self.descargarOConsumirBebida(pasajeros * 2)
	}
	
	override method tienePocaActividad() = comidaConsumida < 50
}

class NaveHospital inherits NaveDePasajeros {
	var property quirofanosPreparados
	
	override method condicionAdicional() = !quirofanosPreparados
	
	override method recibirAmenaza() {
		self.escapar()
		self.avisar()
		quirofanosPreparados = true
	}
}












