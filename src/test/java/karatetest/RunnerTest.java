package karatetest;

import com.intuit.karate.junit5.Karate;

class RunnerTest {
    String resorcesPath = "C:\\Users\\norida.a.paez\\OneDrive - Accenture\\Desktop\\PROYECTO NEQUI\\karate-api-testing\\src\\test\\java\\resources\\karatetest\\";
    @Karate.Test
    Karate candidateTest() {
        return Karate.run("file:\\" + resorcesPath + "Candidate.feature");
    }
    /* @Karate.Test
    Karate processTest() {
        return Karate.run("file:\\"+resorcesPath+"Process.feature");
    } */
}


