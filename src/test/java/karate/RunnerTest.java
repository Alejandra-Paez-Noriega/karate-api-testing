package karate;

import com.intuit.karate.junit5.Karate;

class RunnerTest {
    
    @Karate.Test
    Karate StateTest() {
        return Karate.run("classpath:resources/karate/State.feature");
    }
    @Karate.Test
    Karate JobProfileTest() {
        return Karate.run("classpath:resources/karate/JobProfile.feature");
    }
    @Karate.Test
    Karate OrigenTest() {
        return Karate.run("classpath:resources/karate/Origen.feature");
    }
    @Karate.Test
    Karate PhaseTest() {
        return Karate.run("classpath:resources/karate/Phase.feature");
    }
}


