package karate;

import com.intuit.karate.junit5.Karate;

class StateRunnerTest {
    
    @Karate.Test
    Karate StateTest() {
        return Karate.run("classpath:resources/karate/State.feature");
    }
}
