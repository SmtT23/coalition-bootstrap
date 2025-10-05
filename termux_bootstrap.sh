<!DOCTYPE html>
<html lang="en">
<head>
   <meta charset="UTF-8">
   <meta name="viewport" content="width=device-width, initial-scale=1.0">
   <title>Quantum Quiz Interface</title>
   <script src="https://cdn.tailwindcss.com"></script>
   <link href="https://fonts.googleapis.com/css2?family=Orbitron:wght@400;700&family=Share+Tech+Mono&display=swap" rel="stylesheet">
   <style>
       /* --- FUTURISTIC THEME CSS --- */
       :root {
           --primary-color: #0d0d21;
           --accent-glow: rgba(0, 255, 255, 0.7);
           --text-main: #E0E7FF;
       }

       body {
           font-family: 'Share Tech Mono', monospace;
           background-color: var(--primary-color);
           color: var(--text-main);
           background-image:
               radial-gradient(circle at 10% 90%, rgba(100, 50, 250, 0.1), transparent 30%),
               radial-gradient(circle at 90% 10%, rgba(250, 50, 100, 0.1), transparent 30%);
           animation: background-pulse 20s infinite alternate;
       }

       @keyframes background-pulse {
           from { background-position: 0% 0%; }
           to { background-position: 100% 100%; }
       }

       .container-main {
           background: rgba(13, 13, 33, 0.6);
           border: 1px solid rgba(0, 255, 255, 0.2);
           box-shadow: 0 0 40px rgba(0, 255, 255, 0.1), inset 0 0 15px rgba(0, 255, 255, 0.05);
           backdrop-filter: blur(15px);
           border-radius: 12px;
       }

       .title-header {
           font-family: 'Orbitron', sans-serif;
           text-shadow: 0 0 10px var(--accent-glow);
       }

       .menu-option, .btn-action {
           position: relative;
           background: rgba(255, 255, 255, 0.05);
           border: 1px solid rgba(0, 255, 255, 0.2);
           transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
           overflow: hidden;
       }

       .menu-option:hover, .btn-action:hover {
           box-shadow: 0 0 20px rgba(0, 255, 255, 0.5);
           background: rgba(0, 255, 255, 0.1);
       }

       .progress-bar-container {
           border: 1px solid var(--accent-glow);
           box-shadow: 0 0 10px var(--accent-glow);
       }
       
       .progress-bar {
           background: linear-gradient(90deg, #818cf8, #3b82f6);
           transition: width 0.5s ease-in-out;
           box-shadow: 0 0 8px rgba(59, 130, 246, 0.8);
       }

       .option-btn.correct {
           background-color: rgba(52, 211, 153, 0.2) !important;
           border-color: #34d399 !important;
           box-shadow: 0 0 20px #34d399 !important;
       }

       .option-btn.incorrect {
           background-color: rgba(239, 68, 68, 0.2) !important;
           border-color: #ef4444 !important;
           box-shadow: 0 0 20px #ef4444 !important;
       }

       .rationale-box {
           border-left: 3px solid;
           transition: opacity 0.5s ease;
           background-color: rgba(255, 255, 255, 0.05);
       }

       .rationale-box.correct { border-color: #34d399; }
       .rationale-box.incorrect { border-color: #ef4444; }

   </style>
</head>
<body class="flex items-center justify-center min-h-screen p-4 select-none">

   <div id="quiz-container" class="container-main w-full max-w-3xl p-8 rounded-xl">
       <div id="quiz-header" class="text-center mb-8">
           <h1 class="title-header text-4xl md:text-5xl font-bold text-cyan-400 tracking-wider">CYBER QUIZ</h1>
           <p id="header-subtitle" class="text-slate-400 mt-2 text-sm md:text-base">SYSTEM INITIALIZED...</p>
       </div>

       <div id="main-menu" class="space-y-4">
           <button class="menu-option w-full p-4 rounded-lg text-left text-lg font-bold" data-quiz-type="ru-en-words">
               <span class="text-cyan-400">></span> Russian to English Words
           </button>
           <button class="menu-option w-full p-4 rounded-lg text-left text-lg font-bold" data-quiz-type="ru-en-phrases">
               <span class="text-cyan-400">></span> Russian to English Phrases (NEW)
           </button>
           <button class="menu-option w-full p-4 rounded-lg text-left text-lg font-bold" data-quiz-type="quit">
               <span class="text-red-400">></span> Disconnect Protocol
           </button>
       </div>

       <div id="quiz-content" class="hidden">
           </div>

       <div id="results-screen" class="hidden text-center">
           <h2 class="title-header text-4xl font-bold text-cyan-400 mb-4">ASSESSMENT COMPLETE</h2>
           <p class="text-xl text-slate-300 mb-2">FINAL DATA SYNTHESIS:</p>
           <p id="final-score" class="text-7xl font-bold text-transparent bg-clip-text bg-gradient-to-r from-cyan-400 to-fuchsia-500 mb-6"></p>
           <p id="score-message" class="text-lg text-slate-400 mb-8"></p>
           <button id="restart-btn" class="btn-action text-white font-bold py-3 px-8 rounded-full text-lg w-full">
               RE-INITIALIZE
           </button>
           <button id="results-menu-btn" class="btn-action text-white font-bold py-3 px-8 rounded-full text-lg w-full mt-4">
               RETURN TO MAIN SYSTEM
           </button>
       </div>
   </div>

   <script>
       // --- QUIZ DATA: Includes all new phrases ---
       const quizData = {
           "words": [
               { "ru": "привет", "en": "hello", "hint": "A common greeting for initiating communication." },
               { "ru": "спасибо", "en": "thank you", "hint": "An expression of gratitude." },
               { "ru": "вода", "en": "water", "hint": "The chemical symbol for water is H2O." },
               { "ru": "хлеб", "en": "bread", "hint": "A staple food, often baked." },
               { "ru": "друг", "en": "friend", "hint": "A companion or associate." },
               { "ru": "дом", "en": "house", "hint": "A building for human habitation." },
               { "ru": "солнце", "en": "sun", "hint": "The star at the center of our solar system." },
               { "ru": "кот", "en": "cat", "hint": "A small domesticated carnivorous mammal." }
           ],
           "phrases": [
               { "ru": "Ты красивая", "en": "You are beautiful", "hint": "A common compliment used when speaking to a female." },
               { "ru": "Ты горячая", "en": "You're hot", "hint": "A direct, passionate compliment. (Feminine form)" },
               { "ru": "Ты меня любишь?", "en": "Do you love me?", "hint": "A personal question about deep affection." },
               { "ru": "Сексуальная красивая принцесса", "en": "Sexy beautiful princess", "hint": "A string of three descriptive compliments." },
               { "ru": "Принцесса Саша", "en": "Princess Sasha", "hint": "A royal title followed by a shortened name for Alexandra/Alexander." },
               { "ru": "Как дела?", "en": "How are you?", "hint": "A common inquiry about well-being." },
               { "ru": "Я в порядке.", "en": "I am fine.", "hint": "A typical response to 'How are you?'." },
               { "ru": "До свидания!", "en": "Goodbye!", "hint": "A common farewell." },
               { "ru": "Увидимся позже.", "en": "See you later.", "hint": "An expression indicating a future meeting." }
           ]
       };

       // --- DOM ELEMENTS ---
       const mainMenuEl = document.getElementById('main-menu');
       const quizContentEl = document.getElementById('quiz-content');
       const resultsScreenEl = document.getElementById('results-screen');
       const headerSubtitleEl = document.getElementById('header-subtitle');
       const finalScoreEl = document.getElementById('final-score');
       const scoreMessageEl = document.getElementById('score-message');
       const restartBtn = document.getElementById('restart-btn');
       const resultsMenuBtn = document.getElementById('results-menu-btn');
       
       // --- SPEECH SYNTHESIS SETUP ---
       const synth = window.speechSynthesis;
       let ruVoice = null;
       
       function populateVoiceList() {
           const voices = synth.getVoices();
           for (let i = 0; i < voices.length; i++) {
               if (voices[i].lang.startsWith('ru')) {
                   if (voices[i].name.includes('Katya') || voices[i].name.includes('Milena')) {
                       ruVoice = voices[i];
                       break; 
                   }
                   if (!ruVoice) {
                       ruVoice = voices[i];
                   }
               }
           }
       }
       
       populateVoiceList();
       if (synth.onvoiceschanged !== undefined) {
           synth.onvoiceschanged = populateVoiceList;
       }

       function speak(text, lang, rate = 1.0) {
           if (!synth || !ruVoice) {
               console.warn("Speech API not ready or Russian voice unavailable.");
               return;
           }
           synth.cancel();
           
           const utterance = new SpeechSynthesisUtterance(text);
           utterance.lang = lang;
           utterance.voice = ruVoice;
           utterance.rate = rate; 
           synth.speak(utterance);
       }

       // --- STATE VARIABLES ---
       let currentQuestionIndex = 0;
       let score = 0;
       let answerSelected = false;
       let currentQuizQuestions = [];
       let quizMode = '';

       // --- UTILITY FUNCTION ---
       function shuffleQuizData(data) {
           for (let i = data.length - 1; i > 0; i--) {
               const j = Math.floor(Math.random() * (i + 1));
               [data[i], data[j]] = [data[j], data[i]];
           }
           return data;
       }

       // --- CORE FUNCTIONS ---
       function startQuiz(type) {
           quizMode = type;
           let questionsData = [];
           let quizTitle = '';

           if (type.includes('words')) {
               questionsData = quizData.words;
               quizTitle = 'Russian Words to English';
           } else if (type.includes('phrases')) {
               questionsData = quizData.phrases;
               quizTitle = 'Russian Phrases to English';
           }
           
           if (questionsData.length < 4) { 
               alert('Quiz data is insufficient (need at least 4 items).');
               return;
           }

           currentQuizQuestions = shuffleQuizData([...questionsData]);
           currentQuestionIndex = 0;
           score = 0;

           headerSubtitleEl.textContent = quizTitle.toUpperCase();
           mainMenuEl.classList.add('hidden');
           resultsScreenEl.classList.add('hidden');
           quizContentEl.classList.remove('hidden');
           
           loadQuestion();
       }
       
       // --- FUNCTION TO LOAD THE NEXT QUESTION ---
       function loadQuestion() {
           answerSelected = false;
           const question = currentQuizQuestions[currentQuestionIndex];
           const progress = ((currentQuestionIndex) / currentQuizQuestions.length) * 100;
           
           const questionText = question.ru;
           const correctAnswerText = question.en;

           // 1. Setup answer options
           let options = [correctAnswerText];
           const allPossibleAnswers = currentQuizQuestions.map(q => q.en);
           
           while (options.length < 4) {
               const randomIndex = Math.floor(Math.random() * currentQuizQuestions.length);
               const randomOption = allPossibleAnswers[randomIndex];
               if (!options.includes(randomOption)) {
                   options.push(randomOption);
               }
           }
           shuffleQuizData(options);

           let optionsHtml = '';
           options.forEach(optionText => {
               optionsHtml += `<button class="option-btn menu-option w-full p-4 rounded-lg text-lg text-left" data-correct="${optionText === correctAnswerText}">${optionText}</button>`;
           });

           // 2. Build the question HTML (FIXED TEMPLATE)
           quizContentEl.innerHTML = `
               <div class="mb-6">
                   <div class="flex justify-between items-center mb-2 text-cyan-400">
                       <span class="font-bold">QUESTION ${currentQuestionIndex + 1} / ${currentQuizQuestions.length}</span>
                       <span class="font-bold">SCORE: ${score}</span>
                   </div>
                   <div class="w-full bg-slate-700 rounded-full h-2 progress-bar-container">
                       <div class="progress-bar h-2 rounded-full" style="width: ${progress}%"></div>
                   </div>
               </div>

               <div class="mb-8">
                   <h2 class="text-3xl md:text-4xl font-bold text-slate-100 mb-4">${questionText}</h2>
                   
                   <div class="flex space-x-4 mb-8">
                       <button id="speak-full-btn" class="p-3 rounded-lg border border-cyan-400 text-cyan-400 text-sm hover:bg-cyan-400 hover:text-black transition-colors flex items-center">
                           <svg class="w-5 h-5 mr-1" fill="currentColor" viewBox="0 0 20 20"><path d="M13.58 7.58L10 4v12l3.58-3.58H17V7.58h-3.42z"/></svg>
                           TRANSMIT AUDIO
                       </button>

                       <button id="toggle-hint-btn" class="p-3 rounded-lg border border-slate-400 text-slate-400 text-sm hover:bg-slate-400 hover:text-black transition-colors flex items-center">
                           <svg class="w-5 h-5 mr-1" fill="currentColor" viewBox="0 0 20 20"><path d="M10 2a8 8 0 100 16 8 8 0 000-16zm-1 12H9v-2H8v2h2zm0-4h2V6H9v4z"/></svg>
                           HINT
                       </button>
                   </div>

                   <div id="options-container" class="space-y-4">
                       ${optionsHtml}
                   </div>
               </div>

               <div id="rationale-display" class="rationale-box p-4 rounded-lg text-sm mt-8 hidden"></div>

               <div class="flex space-x-4 mt-8">
                   <button id="next-btn" class="btn-action bg-slate-700 text-white font-bold py-3 px-6 rounded-full w-full opacity-50 cursor-not-allowed" disabled>NEXT QUESTION</button>
               </div>
           `; 

           // 3. Attach Event Listeners
           
           const speakBtn = document.getElementById("speak-full-btn");
           const hintBtn = document.getElementById("toggle-hint-btn");
           const rationaleBox = document.getElementById("rationale-display");
           const nextBtn = document.getElementById("next-btn");
           const optionsContainer = document.getElementById("options-container");
           const hintText = question.hint; // Re-fetch hint text

           // 🔊 Speak the question aloud 
           speakBtn.addEventListener("click", () => {
               speak(question.ru, 'ru-RU', 0.9); 
           });

           // 💡 Toggle hint visibility
           hintBtn.addEventListener("click", () => {
               rationaleBox.textContent = hintText || "No hint available.";
               rationaleBox.classList.remove('correct', 'incorrect');
               rationaleBox.classList.toggle("hidden");
           });

           // ✅ Handle answer selection
           optionsContainer.querySelectorAll("button").forEach(btn => {
               btn.addEventListener("click", () => {
                   // --- LOCKOUT CODE ---
                   if (answerSelected) return; 
                   answerSelected = true;      

                   const selected = btn.textContent.trim();

                   if (selected === correctAnswerText) {
                       score++; 
                       btn.classList.add("correct");
                       rationaleBox.innerHTML = `✅ **CORRECT!**<br>The Russian word is: *${question.ru}*`;
                       rationaleBox.classList.add("correct");
                   } else {
                       btn.classList.add("incorrect");
                       // Highlight the correct answer
                       optionsContainer.querySelectorAll("button").forEach(b => {
                           if (b.textContent.trim() === correctAnswerText) {
                               b.classList.add("correct");
                           }
                       });
                       rationaleBox.innerHTML = `❌ **INCORRECT.**<br>The correct translation was: **${correctAnswerText}**`;
                       rationaleBox.classList.add("incorrect");
                   }

                   // Show rationale and enable next button
                   rationaleBox.classList.remove("hidden");
                   nextBtn.disabled = false;
                   nextBtn.classList.remove("opacity-50", "cursor-not-allowed");
               });
           });

           // ⏭️ Advance to next question or show results
           nextBtn.addEventListener("click", () => {
               if (currentQuestionIndex < currentQuizQuestions.length - 1) {
                   currentQuestionIndex++;
                   loadQuestion();
               } else {
                   showResults(); 
               }
           });
       }

       // --- FUNCTION TO SHOW FINAL RESULTS ---
       function showResults() {
           // 1. Calculate the final percentage score
           const totalQuestions = currentQuizQuestions.length;
           const finalPercentage = ((score / totalQuestions) * 100).toFixed(0); 

           // 2. Handle the screen transition
           quizContentEl.classList.add('hidden');
           resultsScreenEl.classList.remove('hidden');
           headerSubtitleEl.textContent = 'ASSESSMENT COMPLETE';

           // 3. Update the results elements
           finalScoreEl.textContent = `${finalPercentage}%`;
           
           let message = '';
           if (finalPercentage >= 80) {
               message = "STATUS: ONLINE. HIGH-LEVEL DATA SYNCHRONIZATION ACHIEVED.";
           } else if (finalPercentage >= 50) {
               message = "STATUS: FUNCTIONAL. CORE PROTOCOLS IN PLACE. IMPROVEMENT RECOMMENDED.";
           } else {
               message = "STATUS: OFFLINE. CORE KNOWLEDGE BASE FAILURE. RE-INITIALIZATION REQUIRED.";
           }
           scoreMessageEl.textContent = message;
       }


       // --- GLOBAL EVENT LISTENERS ---

       // EVENT HANDLER FOR MAIN MENU BUTTONS
       document.querySelectorAll('.menu-option').forEach(button => {
           button.addEventListener('click', (e) => {
               const type = e.currentTarget.dataset.quizType;
               if (type === 'quit') {
                   headerSubtitleEl.textContent = 'SYSTEM DISCONNECTED';
                   alert('Disconnecting...');
                   // window.close(); // Browser security often prevents this
               } else {
                   startQuiz(type);
               }
           });
       });

       // EVENT HANDLER FOR RESULTS SCREEN BUTTONS
       restartBtn.addEventListener('click', () => {
           // Re-start the quiz using the mode that was just played
           startQuiz(quizMode); 
       });

       resultsMenuBtn.addEventListener('click', () => {
           // Reset state and return to main menu
           currentQuestionIndex = 0;
           score = 0;
           resultsScreenEl.classList.add('hidden');
           mainMenuEl.classList.remove('hidden');
           headerSubtitleEl.textContent = 'SYSTEM INITIALIZED...';
       });

   </script>
</body>
</html>

