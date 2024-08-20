const express = require('express');
const app = express();

app.get("/health-check", (req, res)=> {
    console.log("up");
})

const PORT = process.env.PORT || 7070;
app.listen(PORT, ()=>{
    console.log(`현재 이 서버는 ${PORT}번 포트에서 가동 중입니다.`);
})