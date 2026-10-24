
import SwiftUI

struct DetalleFotoView: View {

    let foto: Foto

    @Environment(\.dismiss) private var dismiss

    // Estado del zoom.
    @State private var escala: CGFloat = 1.0
    @State private var escalaInicial: CGFloat = 1.0

    // Estado del desplazamiento.
    @State private var desplazamiento: CGSize = .zero
    @State private var desplazamientoInicial: CGSize = .zero

    var body: some View {
        ZStack(alignment: .topTrailing) {

            // Fondo negro.
            Color.black
                .ignoresSafeArea()

            // Fotografía con zoom y desplazamiento.
            Image(uiImage: foto.imagen)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .scaleEffect(escala)
                .offset(desplazamiento)
                .gesture(
                    MagnifyGesture()
                        .onChanged { valor in
                            escala = min(
                                max(escalaInicial * valor.magnification, 1.0),
                                5.0
                            )
                        }
                        .onEnded { _ in
                            escalaInicial = escala

                            if escala == 1.0 {
                                desplazamiento = .zero
                                desplazamientoInicial = .zero
                            }
                        }
                )
                .simultaneousGesture(
                    DragGesture()
                        .onChanged { valor in
                            guard escala > 1.0 else { return }

                            desplazamiento = CGSize(
                                width: desplazamientoInicial.width
                                    + valor.translation.width,
                                height: desplazamientoInicial.height
                                    + valor.translation.height
                            )
                        }
                        .onEnded { _ in
                            desplazamientoInicial = desplazamiento
                        }
                )
                .onTapGesture(count: 2) {
                    // Doble toque para ampliar o restablecer.
                    withAnimation(.easeInOut) {
                        if escala > 1.0 {
                            escala = 1.0
                            escalaInicial = 1.0
                            desplazamiento = .zero
                            desplazamientoInicial = .zero
                        } else {
                            escala = 2.0
                            escalaInicial = 2.0
                        }
                    }
                }

            // Botón de cerrar.
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding(12)
                    .background(
                        .ultraThinMaterial,
                        in: Circle()
                    )
            }
            .padding()
        }
        .statusBarHidden()
    }
}
