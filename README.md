
App iOS para brigadas de emergencia post-sismo. Gestión de familias afectadas, tareas de brigada y recursos disponibles.

## Arquitectura

**SwiftUI App + UIKit Navigation híbrido.** El `@main` usa SwiftUI App lifecycle, pero el contenido es un `UITabBarController` embebido vía `UIViewControllerRepresentable`. Esto permite demostrar navegación UIKit real (push, modal, tabs) sin necesidad de AppDelegate/SceneDelegate manuales.

## Decisiones de Diseño

### 1. Enum con Computed Properties para Estados

```swift
enum FamilyStatus: String, Codable, CaseIterable {
    case bien, necesitaRevision, urgente, noLocalizado
    
    var color: UIColor { ... }  // Color derivado del enum
    var icon: String { ... }    // Icono derivado del enum
}
```

**Justificación:** Elimina condicionales (`switch/if`) en ViewControllers y celdas. La celda solo hace `badgeView.backgroundColor = family.estado.color`. Si se agrega un nuevo estado, solo se modifica el enum — no hay que buscar switches dispersos por el código.

### 2. Singleton DataManager con UserDefaults

**Justificación:** Para un MVP offline sin backend, UserDefaults + Codable es la opción más simple que cumple persistencia. Un singleton centraliza el CRUD y notifica cambios vía `NotificationCenter`, evitando acoplar ViewControllers entre sí.

### 3. Custom UITableViewCell programática (sin Storyboard)

**Justificación:** El proyecto usa `PBXFileSystemSynchronizedRootGroup` (Xcode 26) que auto-sincroniza archivos. Celdas programáticas evitan conflictos de merge en XIBs y dan control total del layout con Auto Layout.

### 4. UIViewControllerRepresentable como puente

**Justificación:** Permite usar SwiftUI como punto de entrada (`@main`) mientras toda la navegación es UIKit nativo. El tab de Resumen usa `UIHostingController` con SwiftUI puro — demuestra interoperabilidad bidireccional.

### 5. Filtro con UISegmentedControl en Tareas
ggtgt
**Justificación:** Solución nativa de UIKit para filtrar por estado. No requiere librerías externas. El filtro opera sobre el array en memoria — respuesta inmediata sin queries.

### 6. Datos precargados (Sample Data)

**Justificación:** El `DataManager` detecta si no hay datos y carga 6 familias, 6 tareas y 8 recursos de ejemplo. Permite evaluar la app sin configuración previa. Los datos persisten después del primer lanzamiento.

## Navegación Implementada

| Tipo | Dónde |
|------|-------|
| **Tab** | `UITabBarController` — Resumen, Familias, Tareas, Recursos |
| **Push** | Familias → Detalle Familia (cambio estado + notas) |
| **Modal** | Botón "+" → Formulario nueva familia / nueva tarea |

## Estructura del Proyecto

```
Models/          → Enums, structs Codable, DataManager
ViewControllers/ → UIKit VCs (tabla, detalle, formularios)
Views/           → Custom UITableViewCells
SwiftUI/         → ResumenView (dashboard animado)
```

## Requisitos

- Xcode 26+
- iOS 26.4+
- Sin dependencias externas
## Imagenes
<img width="712" height="1600" alt="WhatsApp Image 2026-05-08 at 3 26 42 PM" src="https://github.com/user-attachments/assets/804f4fad-ee92-4d9e-9d7e-b513b2bbd34b" />
<img width="779" height="1600" alt="image" src="https://github.com/user-attachments/assets/db039bd0-14ef-47e5-8060-cb2854109a1a" />
<img width="836" height="1600" alt="image" src="https://github.com/user-attachments/assets/556a3175-ef25-4d48-97a8-4d642b10d3e6" />
<img width="900" height="1600" alt="image" src="https://github.com/user-attachments/assets/198367c5-dc3d-4650-8212-8cf12852e49b" />


  
