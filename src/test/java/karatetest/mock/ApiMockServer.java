package karatetest.mock;

import java.io.*;
import java.util.Scanner;

public class ApiMockServer {
    public static void main(String[] args) {
        final Process process;
        try {
            // Comando para ejecutar Karate Mock Server
            String command = "java -jar libs/karate-1.4.1.jar -m src/test/java/resources/karate/mock/ApiMock.feature -p 8080";

            // Iniciar el proceso
            ProcessBuilder processBuilder = new ProcessBuilder("cmd.exe", "/c", command);
            processBuilder.redirectErrorStream(true);
            process = processBuilder.start();

            // Hilo para leer la salida del proceso
            new Thread(() -> {
                try (BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()))) {
                    String line;
                    while ((line = reader.readLine()) != null) {
                        System.out.println(line);
                    }
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }).start();

            // Esperar un momento para asegurarnos de que el servidor inicia
            Thread.sleep(5000);

            // Obtener el PID del proceso en el puerto 8080
            int pid = getPIDFromNetstat(8080);
            if (pid > 0) {
                System.out.println("Servidor iniciado en el puerto 8080. PID: " + pid);
            } else {
                System.out.println("⚠️ No se pudo obtener el PID del servidor.");
            }

            System.out.println("Presiona ENTER para detener el servidor...");
            try (Scanner scanner = new Scanner(System.in)) {
                scanner.nextLine();
            }

            // Matar el proceso
            if (pid > 0) {
                System.out.println("\nDeteniendo servidor con PID: " + pid + "...");
                new ProcessBuilder("cmd.exe", "/c", "taskkill /PID " + pid + " /F").inheritIO().start().waitFor();
                System.out.println("✅ Servidor detenido.");
            } else {
                System.out.println("⚠️ No se encontró el PID, intentando destruir el proceso manualmente...");
                process.destroy();
                if (!process.waitFor(5, java.util.concurrent.TimeUnit.SECONDS)) {
                    process.destroyForcibly();
                }
                System.out.println("✅ Proceso detenido manualmente.");
            }

            // Verificar si el puerto sigue ocupado
            if (isPortInUse(8080)) {
                System.out.println("⚠️ El puerto 8080 sigue en uso. Verifica procesos manualmente.");
            } else {
                System.out.println("✅ Puerto 8080 liberado correctamente.");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Método para obtener el PID del proceso en el puerto especificado usando netstat
    private static int getPIDFromNetstat(int port) {
        try {
            ProcessBuilder processBuilder = new ProcessBuilder("cmd.exe", "/c", "netstat -ano | findstr " + port);
            Process netstatProcess = processBuilder.start();
            BufferedReader reader = new BufferedReader(new InputStreamReader(netstatProcess.getInputStream()));
            String line;
            while ((line = reader.readLine()) != null) {
                System.out.println("? " + line); // Mostrar lo que encuentra
                String[] parts = line.trim().split("\\s+");
                if (parts.length >= 5 && "LISTENING".equals(parts[3])) {
                    return Integer.parseInt(parts[4]); // El PID está en la última columna
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    // Método para verificar si un puerto está en uso
    private static boolean isPortInUse(int port) {
        try {
            ProcessBuilder processBuilder = new ProcessBuilder("cmd.exe", "/c", "netstat -ano | findstr :" + port);
            Process netstatProcess = processBuilder.start();
            BufferedReader reader = new BufferedReader(new InputStreamReader(netstatProcess.getInputStream()));
            return reader.readLine() != null; // Si hay salida, el puerto sigue en uso
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
