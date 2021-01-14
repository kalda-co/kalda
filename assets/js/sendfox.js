! function (e) {
  var t = {};

  function r(n) {
    if (t[n]) return t[n].exports;
    var a = t[n] = {
      i: n,
      l: !1,
      exports: {}
    };
    return e[n].call(a.exports, a, a.exports, r), a.l = !0, a.exports
  }
  r.m = e, r.c = t, r.d = function (e, t, n) {
    r.o(e, t) || Object.defineProperty(e, t, {
      configurable: !1,
      enumerable: !0,
      get: n
    })
  }, r.n = function (e) {
    var t = e && e.__esModule ? function () {
      return e.default
    } : function () {
      return e
    };
    return r.d(t, "a", t), t
  }, r.o = function (e, t) {
    return Object.prototype.hasOwnProperty.call(e, t)
  }, r.p = "", r(r.s = 2)
}({
  2: function (e, t, r) {
    e.exports = r("PfAn")
  },
  PfAn: function (e, t, r) {
    window.SENDFOX_FORM_LOADED || (window.SENDFOX_FORM_LOADED = !0, document.addEventListener("DOMContentLoaded", function () {
      for (var e = document.getElementsByClassName("sendfox-form"), t = !1, r = 0; r < e.length; r++) {
        if ("true" === e[r].dataset.recaptcha && !t) {
          var a = document.createElement("script");
          a.type = "text/javascript", a.src = "https://www.google.com/recaptcha/api.js?render=6Lemwu0UAAAAAJghn3RQZjwkYxnCTuYDCAcrJJ7S";
          var s = document.getElementsByTagName("script")[0];
          s.parentNode.insertBefore(a, s), t = !0
        }
        e[r].addEventListener("submit", function (e) {
          e.preventDefault();
          var t = this;
          "true" === t.dataset.recaptcha ? window.grecaptcha.ready(function () {
            window.grecaptcha.execute("6Lemwu0UAAAAAJghn3RQZjwkYxnCTuYDCAcrJJ7S", {
              action: "embedded_form"
            }).then(function (e) {
              var r = document.createElement("input");
              r.setAttribute("name", "g-recaptcha-response"), r.setAttribute("value", e), r.setAttribute("type", "hidden"), t.appendChild(r), n(t)
            }).catch(function (e) {
              console.error("Recaptcha failed."), n(t)
            })
          }) : n(t)
        })
      }
    }));
    var n = function (e) {
      if ("true" === e.dataset.async) {
        e.querySelector(".sendfox-message") && e.querySelector(".sendfox-message").remove();
        var t = e.querySelector("button");
        t.disabled = !0;
        var r = new XMLHttpRequest;
        r.addEventListener("load", function (n, a) {
          var s = JSON.parse(r.responseText);
          if (422 == n.currentTarget.status) {
            if (s.hasOwnProperty("errors")) {
              var o = document.createElement("p");
              o.className = "sendfox-message error", o.innerHTML = s.errors[0], e.appendChild(o)
            }
          } else if (200 == n.currentTarget.status)
            if (s.redirect_url) window.location.href = s.redirect_url;
            else {
              var c = document.createElement("p");
              c.className = "sendfox-message success", c.innerHTML = "Thanks, your signup was successful!", e.appendChild(c), e.reset()
            } t.disabled = !1
        }), r.addEventListener("error", function (e) {
          console.error("Error submitting form."), t.disabled = !1
        }), r.open("POST", e.action), r.setRequestHeader("X-Requested-With", "XMLHttpRequest"), r.send(new FormData(e))
      } else e.submit()
    }
  }
});
